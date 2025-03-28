package service

import (
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type CategoryService interface {
	GetVetSpecialties() (*[]model.VetSpecialty, error);
	GetPetCategories()(*[]model.PetCategoryDTO, error);
	GetSizeCategories()(*[]model.SizeCategory, error);
}

type CategoryServiceImpl struct {
	db *gorm.DB
}

func NewCategoryService(db *gorm.DB) *CategoryServiceImpl {
	return &CategoryServiceImpl{db: db};
}

func (s *CategoryServiceImpl) GetVetSpecialties() (*[]model.VetSpecialty, error) {
	var vetSpecialties []model.VetSpecialty

	if err := s.db.Find(&vetSpecialties).Error; err != nil {
		return nil, err
	}

	return &vetSpecialties, nil
}

func (s *CategoryServiceImpl) GetPetCategories()(*[]model.PetCategoryDTO, error) {
	var petCategories []model.PetCategory
	var dto []model.PetCategoryDTO

	if err := s.db.
		Preload("SizeCategory").
		Find(&petCategories).Error; err != nil {
		return nil, err
	}

	for _, val := range petCategories {
		dto = append(dto, model.PetCategoryDTO{
			ID: val.ID,
			Name: val.Name,
			SizeCategory: val.SizeCategory,
		})
	}

	return &dto, nil
}

func (s *CategoryServiceImpl) GetSizeCategories()(*[]model.SizeCategory, error) {
	var sizeCategories []model.SizeCategory

	if err := s.db.Find(&sizeCategories).Error; err != nil {
		return nil, err
	}

	return &sizeCategories, nil
}