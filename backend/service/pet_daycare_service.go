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
	GetPetDaycare(id uint, lat float64, long float64) (*model.GetPetDaycareDetailResponse, error)
	DeletePetDaycare(id uint, ownerId uint) error
	UpdatePetDaycare(id uint, userId uint, newData model.CreatePetDaycareRequest) (*model.PetDaycareDTO, error)

	// TODO
	// BookSlots() error
}

type PetDaycareServiceImpl struct {
	db *gorm.DB
}

func NewPetDaycareService(db *gorm.DB) *PetDaycareServiceImpl {
	return &PetDaycareServiceImpl{db: db}
}

func (s *PetDaycareServiceImpl) GetPetDaycare(id uint, lat float64, long float64)) (*model.GetPetDaycareDetailResponse, error) {
	var daycare model.PetDaycare

	if err := s.db.
		Preload("Owner").
		Preload("DailyWalks").
		Preload("DailyPlaytime").
		Preload("Thumbnails").
		Preload("Reviews").
		First(&daycare, id).Error; err != nil {
		return nil, err
	}

	distance := 0.0
	if lat != 0.0 && long != 0.0{
		distance = helper.CalculateDistance(lat, long, daycare.Latitude, daydaycare.Longitude)
	}

	helper.ConvertPetDaycareToDetailResponse(daycare, distance)
}

func (s *PetDaycareServiceImpl) UpdatePetDaycare(id uint, userId uint, newData model.CreatePetDaycareRequest) (*model.PetDaycareDTO, error) {
	tx := s.db.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()
	var daycare model.PetDaycare
	if err := tx.
		Preload("Thumbnails").
		Preload("Slots").
		Where("id = ? AND owner_id = ?", id, userId).
		First(&daycare).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	// Update basic fields
	daycare.Name = newData.Name
	daycare.Address = newData.Address
	daycare.Description = newData.Description
	daycare.Price = newData.Price
	daycare.PricingType = newData.PricingType
	daycare.HasPickupService = newData.HasPickupService
	daycare.MustBeVaccinated = newData.MustBeVaccinated
	daycare.GroomingAvailable = newData.GroomingAvailable
	daycare.FoodProvided = newData.FoodProvided
	daycare.FoodBrand = newData.FoodBrand
	daycare.DailyWalksID = newData.DailyWalksID
	daycare.DailyPlaytimeID = newData.DailyPlaytimeID

	// Handle new thumbnails if provided
	if len(newData.Thumbnails) > 0 {
		// Delete old thumbnails
		if err := tx.Where("daycare_id = ?", daycare.ID).Delete(&model.Thumbnail{}).Error; err != nil {
			tx.Rollback()
			return nil, err
		}

		// Save new thumbnails
		var thumbnails []model.Thumbnail
		for _, thumbnailURL := range newData.ThumbnailURLs {
			// filePath, err := helper.UploadImage(file) // Implement this function to handle file uploads
			// if err != nil {
			tx.Rollback()
			// 	return nil, err
			// }
			thumbnails = append(thumbnails, model.Thumbnail{DaycareID: daycare.ID, ImageUrl: thumbnailURL})
		}
		if err := tx.Create(&thumbnails).Error; err != nil {
			tx.Rollback()
			return nil, err
		}

		daycare.Thumbnails = thumbnails
	}

	// Handle Slots update (SpeciesID + SizeCategoryID + MaxNumber)
	if len(newData.SpeciesID) > 0 && len(newData.SizeCategoryID) > 0 && len(newData.MaxNumber) > 0 {
		// Delete old slots
		if err := tx.Where("daycare_id = ?", daycare.ID).Delete(&model.Slots{}).Error; err != nil {
			tx.Rollback()
			return nil, err
		}

		// Insert new slots
		var slots []model.Slots
		for i := range newData.SpeciesID {
			slots = append(slots, model.Slots{
				DaycareID:      daycare.ID,
				SpeciesID:      newData.SpeciesID[i],
				SizeCategoryID: newData.SizeCategoryID[i],
				MaxNumber:      newData.MaxNumber[i],
			})
		}

		if err := tx.Create(&slots).Error; err != nil {
			tx.Rollback()
			return nil, err
		}
		daycare.Slots = slots
	}

	// Save updates
	if err := tx.Save(&daycare).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	if err := tx.Commit().Error; err != nil {
		return nil, err
	}

	// Convert to DTO and return response
	return &model.PetDaycareDTO{
		ID:                daycare.ID,
		Name:              daycare.Name,
		Address:           daycare.Address,
		Description:       daycare.Description,
		Price:             daycare.Price,
		PricingType:       daycare.PricingType,
		HasPickupService:  daycare.HasPickupService,
		MustBeVaccinated:  daycare.MustBeVaccinated,
		GroomingAvailable: daycare.GroomingAvailable,
		FoodProvided:      daycare.FoodProvided,
		FoodBrand:         daycare.FoodBrand,
		ThumbnailURLs:     newData.ThumbnailURLs,
		UpdatedAt:         daycare.UpdatedAt,
	}, nil
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

	output := helper.ConvertPetDaycareToDTO(daycare)
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
