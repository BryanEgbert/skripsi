package service

import (
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type CategoryService interface {
	GetVetSpecialties() (*[]model.VetSpecialty, error);
	GetSpecies()(*[]model.Species, error);
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

func (s *CategoryServiceImpl) GetSpecies()(*[]model.Species, error) {
	var species []model.Species

	if err := s.db.Find(&species).Error; err != nil {
		return nil, err
	}

	return &species, nil
}

func (s *CategoryServiceImpl) GetSizeCategories()(*[]model.SizeCategory, error) {
	var sizeCategories []model.SizeCategory

	if err := s.db.Find(&sizeCategories).Error; err != nil {
		return nil, err
	}

	return &sizeCategories, nil
}