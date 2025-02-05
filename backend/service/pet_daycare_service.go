package service

import (
	"fmt"

	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type PetDaycareService interface {
	CreatePetDaycare(userId uint, request model.CreatePetDaycareRequest) (*model.PetDaycare, error)
}

type PetDaycareServiceImpl struct {
	db *gorm.DB
}

func NewPetDaycareService(db *gorm.DB) *PetDaycareServiceImpl {
	return &PetDaycareServiceImpl{db: db}
}

func (s *PetDaycareServiceImpl) CreatePetDaycare(userId uint, request model.CreatePetDaycareRequest) (*model.PetDaycare, error) {
	// if request.Name == "" || request.Address == "" || request.OwnerID == 0 {
	// 	return nil, errors.New("missing required fields")
	// }

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

	var slots []model.Slots
	for _, slot := range request.Slots {
		// Validate SpeciesID
		var speciesExists bool
		err := tx.Model(&model.Species{}).Select("count(*) > 0").Where("id = ?", slot.SpeciesID).Find(&speciesExists).Error
		if err != nil || !speciesExists {
			tx.Rollback()
			return nil, fmt.Errorf("invalid species ID: %d", slot.SpeciesID)
		}

		// Validate SizeCategoryID
		var sizeExists bool
		err = tx.Model(&model.SizeCategory{}).Select("count(*) > 0").Where("id = ?", slot.SizeCategoryID).Find(&sizeExists).Error
		if err != nil || !sizeExists {
			tx.Rollback()
			return nil, fmt.Errorf("invalid size category ID: %d", slot.SizeCategoryID)
		}

		slots = append(slots, model.Slots{
			DaycareID:      daycare.ID,
			SpeciesID:      slot.SpeciesID,
			SizeCategoryID: slot.SizeCategoryID,
			MaxNumber:      slot.MaxNumber,
		})
	}
	if len(slots) > 0 {
		if err := tx.Create(&slots).Error; err != nil {
			tx.Rollback()
			return nil, err
		}
	}

	tx.Commit()

	return &daycare, nil
}
