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
	GetMyPetDaycare(userId uint) (*model.GetPetDaycareDetailResponse, error)
	GetPetDaycares(req model.GetPetDaycaresRequest, startID uint, pageSize int) (model.ListData[model.GetPetDaycaresResponse], error)
	GetPetDaycare(id uint, lat *float64, long *float64) (*model.GetPetDaycareDetailResponse, error)
	DeletePetDaycare(id uint, ownerId uint) error
	UpdatePetDaycare(id uint, userId uint, newData model.CreatePetDaycareRequest) (*model.PetDaycareDTO, error)
}

type PetDaycareServiceImpl struct {
	db *gorm.DB
}

func NewPetDaycareService(db *gorm.DB) *PetDaycareServiceImpl {
	return &PetDaycareServiceImpl{db: db}
}

func (s *PetDaycareServiceImpl) GetMyPetDaycare(userId uint) (*model.GetPetDaycareDetailResponse, error) {
	daycare := model.PetDaycare{
		OwnerID: userId,
	}

	if err := s.db.
		Preload("Owner").
		Preload("Owner.Role").
		Preload("DailyWalks").
		Preload("DailyPlaytime").
		Preload("Thumbnails").
		Preload("Reviews").
		Preload("Slots").
		Preload("Slots.PetCategory").
		Preload("Slots.PetCategory.SizeCategory").
		First(&daycare).Error; err != nil {
		return nil, err
	}

	dto := helper.ConvertPetDaycareToDetailResponse(daycare, 0)

	return &dto, nil
}

func (s *PetDaycareServiceImpl) GetPetDaycare(id uint, lat *float64, long *float64) (*model.GetPetDaycareDetailResponse, error) {
	var daycare model.PetDaycare

	// Use ST_DistanceSphere to calculate the distance if coordinates are provided
	if lat != nil && long != nil {
		if err := s.db.
			Preload("Owner").
			Preload("Owner.Role").
			Preload("DailyWalks").
			Preload("DailyPlaytime").
			Preload("Thumbnails").
			Preload("Reviews").
			Preload("Slots").
			Preload("Slots.PetCategory").
			Preload("Slots.PetCategory.SizeCategory").
			Select("*, ST_DistanceSphere(ST_MakePoint(?, ?), ST_MakePoint(longitude, latitude)) AS Distance", long, lat).
			First(&daycare, id).Error; err != nil {
			return nil, err
		}
	} else {
		if err := s.db.
			Preload("Owner").
			Preload("Owner.Role").
			Preload("DailyWalks").
			Preload("DailyPlaytime").
			Preload("Thumbnails").
			Preload("Reviews").
			Preload("Slots").
			Preload("Slots.PetCategory").
			Preload("Slots.PetCategory.SizeCategory").
			Find(&daycare, id).Error; err != nil {
			return nil, err
		}
	}

	output := helper.ConvertPetDaycareToDetailResponse(daycare, daycare.Distance)

	return &output, nil
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
	daycare.Name = newData.PetDaycareName
	daycare.Address = newData.Address
	daycare.Description = newData.Description
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
			// tx.Rollback()
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
	if len(newData.PetCategoryID) > 0 && len(newData.MaxNumber) > 0 {
		// Delete old slots
		if err := tx.Where("daycare_id = ?", daycare.ID).Delete(&model.Slots{}).Error; err != nil {
			tx.Rollback()
			return nil, err
		}

		// Insert new slots
		var slots []model.Slots
		for i := range newData.PetCategoryID {
			slots = append(slots, model.Slots{
				DaycareID:     daycare.ID,
				PetCategoryID: newData.PetCategoryID[i],
				MaxNumber:     newData.MaxNumber[i],
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
		HasPickupService:  daycare.HasPickupService,
		MustBeVaccinated:  daycare.MustBeVaccinated,
		GroomingAvailable: daycare.GroomingAvailable,
		FoodProvided:      daycare.FoodProvided,
		FoodBrand:         daycare.FoodBrand,
		ThumbnailURLs:     newData.ThumbnailURLs,
		UpdatedAt:         daycare.UpdatedAt,
	}, nil
}

func (s *PetDaycareServiceImpl) GetPetDaycares(req model.GetPetDaycaresRequest, startID uint, pageSize int) (model.ListData[model.GetPetDaycaresResponse], error) {
	results := []model.GetPetDaycaresResponse{}

	var latitude float64 = 0.0
	var longitude float64 = 0.0
	isCoordinateNotNil := req.Latitude != nil && req.Longitude != nil

	if isCoordinateNotNil {
		latitude = *req.Latitude
		longitude = *req.Longitude
	}

	query := s.db.Table("pet_daycares").
		Select("pet_daycares.id", "pet_daycares.name", "pet_daycares.locality", fmt.Sprintf("ST_DistanceSphere(ST_MakePoint(%f, %f), ST_MakePoint(longitude, latitude))", longitude, latitude), "pet_daycares.booked_num").
		Joins("JOIN daily_playtimes ON daily_playtimes.id = pet_daycares.daily_playtime_id").
		Joins("JOIN daily_walks ON daily_walks.id = pet_daycares.daily_walks_id")

	if req.MaxDistance > 0 && isCoordinateNotNil {
		query = query.Where(
			"ST_DistanceSphere(ST_MakePoint(longitude, latitude), ST_MakePoint(?, ?)) BETWEEN ? AND ?",
			req.Longitude,
			req.Latitude,
			req.MinDistance,
			req.MaxDistance)
	}

	if req.MustBeVaccinated != nil {
		query = query.Where("must_be_vaccinated = ?", req.MustBeVaccinated)
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

	if req.DailyPlaytime != 0 {
		query = query.Where("daily_playtimes.id = ?", req.DailyPlaytime)
	}

	if req.DailyWalks != 0 {
		query = query.Where("daily_walks.id", req.DailyWalks)
	}

	if req.PricingType != nil {
		query = query.Where("pricing_type = ?", *req.PricingType)
	}

	rows, err := query.Rows()
	if err != nil {
		return model.ListData[model.GetPetDaycaresResponse]{Data: results}, err
	}
	defer rows.Close()

	for rows.Next() {
		daycare := model.GetPetDaycaresResponse{Prices: []model.PriceDetails{}}

		rows.Scan(&daycare.ID, &daycare.Name, &daycare.Locality, &daycare.Distance, &daycare.BookedNum)
		results = append(results, daycare)
	}

	for i, result := range results {
		row := s.db.Table("thumbnails").Select("image_url").Where("daycare_id = ?", result.ID).Limit(1).Row()
		row.Scan(&results[i].Thumbnail)

		rows, err := s.db.Table("slots").
			Select("pet_categories.id", "pet_categories.name", "size_categories.*", "slots.price", "slots.pricing_type").
			Joins("JOIN pet_categories ON pet_categories.id = slots.pet_category_id").
			Joins("JOIN size_categories ON size_categories.id = pet_categories.size_category_id").
			Where("slots.daycare_id = ?", result.ID).
			Rows()
		if err != nil {
			return model.ListData[model.GetPetDaycaresResponse]{Data: []model.GetPetDaycaresResponse{}}, err
		}
		defer rows.Close()

		for rows.Next() {
			var price model.PriceDetails
			rows.Scan(&price.PetCategory.ID, &price.PetCategory.Name, &price.PetCategory.SizeCategory.ID, &price.PetCategory.SizeCategory.Name, &price.PetCategory.SizeCategory.MinWeight, &price.PetCategory.SizeCategory.MaxWeight, &price.Price, &price.PricingType)

			results[i].Prices = append(results[i].Prices, price)
		}

		rows, err = s.db.Table("reviews").
			Select("COUNT(*) AS rating_count, AVG(rate) AS average_rating").
			Where("daycare_id = ?", result.ID).
			Rows()
		if err != nil {
			return model.ListData[model.GetPetDaycaresResponse]{Data: []model.GetPetDaycaresResponse{}}, err
		}
		defer rows.Close()

		for rows.Next() {
			rows.Scan(&results[i].RatingCount, &results[i].AverageRating)
		}
	}

	return model.ListData[model.GetPetDaycaresResponse]{Data: results}, nil
}

func (s *PetDaycareServiceImpl) CreatePetDaycare(userId uint, request model.CreatePetDaycareRequest) (*model.PetDaycareDTO, error) {
	var user model.User

	s.db.First(&user, userId)

	if user.RoleID != 2 {
		return nil, errors.New("user cannot create pet daycare")
	}

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
		Name:              request.PetDaycareName,
		Address:           request.Address,
		Locality:          request.Locality,
		Latitude:          request.Latitude,
		Longitude:         request.Longitude,
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
	for i, petCategory := range request.PetCategoryID {
		// Validate SpeciesID
		var petCategoryExists bool
		err := tx.Model(&model.PetCategory{}).Select("count(*) > 0").Where("id = ?", petCategory).Find(&petCategoryExists).Error
		if err != nil || !petCategoryExists {
			tx.Rollback()
			return nil, fmt.Errorf("invalid pet category ID: %d", petCategory)
		}

		slots = append(slots, model.Slots{
			DaycareID:     daycare.ID,
			PetCategoryID: petCategory,
			MaxNumber:     request.MaxNumber[i],
			Price:         request.Price[i],
			PricingType:   request.PricingType[i],
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
	daycare := model.PetDaycare{
		Model:   gorm.Model{ID: id},
		OwnerID: ownerId,
	}
	if err := s.db.
		Preload("Owner").
		Preload("BookedSlots", "end_date > CURRENT_TIMESTAMP").
		Preload("Thumbnails").
		Find(&daycare).
		Error; err != nil {
		return err
	}

	if len(daycare.BookedSlots) != 0 {
		return errors.New("There are pets booked in your pet daycare")
	}

	if err := s.db.
		Unscoped().
		Delete(&model.PetDaycare{Model: gorm.Model{ID: id}, OwnerID: ownerId}).Error; err != nil {
		return err
	}

	for _, thumbnail := range daycare.Thumbnails {
		if err := os.Remove(helper.GetFilePath(thumbnail.ImageUrl)); err != nil {
			return err
		}
	}

	return nil
}
