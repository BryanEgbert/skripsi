package service

import (
	"errors"
	"fmt"
	"os"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type PetDaycareService interface {
	CreatePetDaycare(userId uint, request model.CreatePetDaycareRequest) (*model.PetDaycareDTO, error)
	GetPetDaycares(req model.GetPetDaycaresRequest) ([]model.GetPetDaycaresResponse, error)
	DeletePetDaycare(id uint, ownerId uint) error

	// TODO
	// BookSlots() error
}

type PetDaycareServiceImpl struct {
	db *gorm.DB
}

func NewPetDaycareService(db *gorm.DB) *PetDaycareServiceImpl {
	return &PetDaycareServiceImpl{db: db}
}

func (s *PetDaycareServiceImpl) GetPetDaycares(req model.GetPetDaycaresRequest) ([]model.GetPetDaycaresResponse, error) {
	var daycares []model.PetDaycare
	query := s.db

	// Apply filters
	// TODO: change this
	if req.MinDistance != nil && req.MaxDistance != nil {
		query = query.Where(
			"ST_Distance_Sphere(POINT(longitude, latitude), POINT(?, ?)) BETWEEN ? AND ?",
			req.Longitude,
			req.Latitude,
			*req.MinDistance,
			*req.MaxDistance)
	}

	if len(req.Facilities) > 0 {
		for _, facility := range req.Facilities {
			switch facility {
			case "pickup":
				query = query.Where("has_pickup_service = ?", true)
			case "grooming":
				query = query.Where("grooming_available = ?", true)
			case "food":
				query = query.Where("food_provided = ?", true)
			}
		}
	}

	if req.MinPrice != nil {
		query = query.Where("price >= ?", *req.MinPrice)
	}
	if req.MaxPrice != nil {
		query = query.Where("price <= ?", *req.MaxPrice)
	}
	if req.PricingType != nil {
		query = query.Where("pricing_type = ?", *req.PricingType)
	}
	if req.MustBeVaccinated {
		query = query.Where("must_be_vaccinated = ?", req.MustBeVaccinated)
	}

	// Fetch daycare data
	if err := query.
		Preload("Owner").
		Preload("Reviews").
		Preload("Thumbnails").
		Find(&daycares).Error; err != nil {
		return nil, err
	}

	// Transform result
	var results []model.GetPetDaycaresResponse
	for _, daycare := range daycares {
		distance := helper.CalculateDistance(req.Latitude, req.Longitude, daycare.Latitude, daycare.Longitude)
		avgRating, ratingCount := helper.CalculateRatings(daycare.Reviews)

		var firstThumbnail string
		if len(daycare.Thumbnails) > 0 {
			firstThumbnail = daycare.Thumbnails[0].ImageUrl
		}

		results = append(results, model.GetPetDaycaresResponse{
			ID:            daycare.ID,
			Name:          daycare.Name,
			Distance:      distance,
			ProfileImage:  daycare.Owner.ImageUrl,
			AverageRating: avgRating,
			RatingCount:   ratingCount,
			BookedNum:     daycare.BookedNum,
			Price:         daycare.Price,
			Thumbnail:     firstThumbnail,
		})
	}

	return results, nil
}

func (s *PetDaycareServiceImpl) CreatePetDaycare(userId uint, request model.CreatePetDaycareRequest) (*model.PetDaycareDTO, error) {
	var user model.User

	s.db.First(&user, userId)

	if user.RoleID != 2 {
		return nil, errors.New("User cannot create pet daycare")
	}

	// TODO: get longitude and latitude
	var longitude float64
	var latitude float64

	tx := s.db.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	if err := tx.Error; err != nil {
		return nil, err
	}

	daycare := model.PetDaycare{
		Name:              request.Name,
		Address:           request.Address,
		Latitude:          latitude,
		Longitude:         longitude,
		Description:       request.Description,
		OwnerID:           userId,
		HasPickupService:  request.HasPickupService,
		MustBeVaccinated:  request.MustBeVaccinated,
		GroomingAvailable: request.GroomingAvailable,
		FoodProvided:      request.FoodProvided,
		FoodBrand:         request.FoodBrand,
		DailyWalksID:      request.DailyWalksID,
		DailyPlaytimeID:   request.DailyPlaytimeID,
	}

	if err := tx.Create(&daycare).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	var thumbnails []model.Thumbnail
	for _, thumbnailURL := range request.ThumbnailURLs {
		thumbnails = append(thumbnails, model.Thumbnail{
			DaycareID: daycare.ID,
			ImageUrl:  thumbnailURL,
		})
	}

	if err := tx.Create(&thumbnails).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	var slots []model.Slots
	for i, species := range request.SpeciesID {
		// Validate SpeciesID
		var speciesExists bool
		err := tx.Model(&model.Species{}).Select("count(*) > 0").Where("id = ?", species).Find(&speciesExists).Error
		if err != nil || !speciesExists {
			tx.Rollback()
			return nil, fmt.Errorf("invalid species ID: %d", species)
		}

		// Validate SizeCategoryID
		var sizeExists bool
		err = tx.Model(&model.SizeCategory{}).Select("count(*) > 0").Where("id = ?", request.SizeCategoryID[i]).Find(&sizeExists).Error
		if err != nil || !sizeExists {
			tx.Rollback()
			return nil, fmt.Errorf("invalid size category ID: %d", request.SizeCategoryID[i])
		}

		slots = append(slots, model.Slots{
			DaycareID:      daycare.ID,
			SpeciesID:      species,
			SizeCategoryID: request.SizeCategoryID[i],
			MaxNumber:      request.MaxNumber[i],
		})
	}

	if len(slots) > 0 {
		if err := tx.Create(&slots).Error; err != nil {
			tx.Rollback()
			return nil, err
		}
	}

	tx.Commit()

	daycare.Thumbnails = thumbnails
	daycare.Slots = slots
	daycare.Owner = user

	output := model.ConvertPetDaycareToDTO(daycare)
	return &output, nil
}

func (s *PetDaycareServiceImpl) DeletePetDaycare(id uint, ownerId uint) error {
	var daycare model.PetDaycare
	if err := s.db.
		Preload("Owner").
		Preload("BookedSlots").
		Preload("Thumbnails").
		Where("pet_daycares.id = ? AND owner_id = ?", id, ownerId).
		Find(&daycare).
		Error; err != nil {
		return err
	}

	if len(daycare.BookedSlots) != 0 {
		return errors.New("There are pets booked in your pet daycare")
	}

	if err := s.db.Unscoped().Delete(&daycare, id).Error; err != nil {
		return err
	}

	for _, thumbnail := range daycare.Thumbnails {
		if err := os.Remove(helper.GetFilePath(thumbnail.ImageUrl)); err != nil {
			return err
		}
	}

	return nil
}
