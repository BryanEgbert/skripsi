package service

import (
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type CategoryService interface {
	GetVetSpecialties(language string) (*[]model.VetSpecialty, error)
	GetPetCategories(language string) (*[]model.PetCategoryDTO, error)
	GetSizeCategories(language string) (*[]model.SizeCategory, error)
	GetDailyWalks(language string) (*[]model.DailyWalks, error)
	GetDailyPlaytime(language string) (*[]model.DailyPlaytime, error)
	GetPricingType(language string) (*[]model.PricingType, error)
}

type CategoryServiceImpl struct {
	db *gorm.DB
}

func NewCategoryService(db *gorm.DB) *CategoryServiceImpl {
	return &CategoryServiceImpl{db: db}
}

func (s *CategoryServiceImpl) GetPricingType(language string) (*[]model.PricingType, error) {
	var pricingTypes []model.PricingType

	if err := s.db.Find(&pricingTypes).Error; err != nil {
		return nil, err
	}

	return &pricingTypes, nil
}

func (s *CategoryServiceImpl) GetVetSpecialties(language string) (*[]model.VetSpecialty, error) {
	var vetSpecialties []model.VetSpecialty

	if err := s.db.Find(&vetSpecialties).Error; err != nil {
		return nil, err
	}

	return &vetSpecialties, nil
}

func (s *CategoryServiceImpl) GetPetCategories(language string) (*[]model.PetCategoryDTO, error) {
	var petCategories []model.PetCategory
	var dto []model.PetCategoryDTO

	if err := s.db.
		Preload("SizeCategory").
		Find(&petCategories).Error; err != nil {
		return nil, err
	}

	for _, val := range petCategories {
		dto = append(dto, model.PetCategoryDTO{
			ID:           val.ID,
			Name:         val.Name,
			SizeCategory: val.SizeCategory,
		})
	}

	return &dto, nil
}

func (s *CategoryServiceImpl) GetSizeCategories(language string) (*[]model.SizeCategory, error) {
	var sizeCategories []model.SizeCategory

	if err := s.db.Find(&sizeCategories).Error; err != nil {
		return nil, err
	}

	return &sizeCategories, nil
}

func (s *CategoryServiceImpl) GetDailyWalks(language string) (*[]model.DailyWalks, error) {
	var dailyWalks []model.DailyWalks

	if err := s.db.Find(&dailyWalks).Error; err != nil {
		return nil, err
	}

	return &dailyWalks, nil
}

func (s *CategoryServiceImpl) GetDailyPlaytime(language string) (*[]model.DailyPlaytime, error) {
	var dailyPlaytimes []model.DailyPlaytime

	if err := s.db.Find(&dailyPlaytimes).Error; err != nil {
		return nil, err
	}

	return &dailyPlaytimes, nil
}
