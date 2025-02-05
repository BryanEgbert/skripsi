package service

import (
	"os"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type PetService interface {
	GetPet(id uint) (*model.PetDTO, error)
	GetPets(ownerID uint, startID int64, pageSize int) (*[]model.PetDTO, error)
	CreatePet(ownerID uint, req model.PetRequest) (*model.PetDTO, error)
	UpdatePet(id uint, pet model.PetDTO) (*model.PetDTO, error)
	DeletePet(id uint) error
}

type PetServiceImpl struct {
	db *gorm.DB
}

func NewPetService(db *gorm.DB) PetService {
	return &PetServiceImpl{db: db}
}

// GetPet fetches a single pet by ID, joining with Species and SizeCategory
func (s *PetServiceImpl) GetPet(id uint) (*model.PetDTO, error) {
	var pet model.Pet
	err := s.db.Preload("Species").Preload("SizeCategory").First(&pet, id).Error
	if err != nil {
		return nil, err
	}

	petDTO := model.PetDTO{
		ID:           pet.ID,
		Name:         pet.Name,
		ImageUrl:     pet.ImageUrl,
		Status:       pet.Status,
		Species:      pet.Species,
		SizeCategory: pet.SizeCategory,
	}

	return &petDTO, nil
}

// GetPets implements cursor-based pagination
// GetPets fetches pets owned by a specific user using cursor-based pagination
func (s *PetServiceImpl) GetPets(ownerID uint, startID int64, pageSize int) (*[]model.PetDTO, error) {
	var pets []model.Pet
	query := s.db.Preload("Species").Preload("SizeCategory").Where("owner_id = ?", ownerID).Order("id ASC").Limit(pageSize)

	if startID > 0 {
		query = query.Where("id > ?", startID)
	}

	err := query.Find(&pets).Error
	if err != nil {
		return nil, err
	}

	var petDTOs []model.PetDTO
	for _, pet := range pets {
		petDTOs = append(petDTOs, model.PetDTO{
			ID:           pet.ID,
			Name:         pet.Name,
			ImageUrl:     pet.ImageUrl,
			Status:       pet.Status,
			Species:      pet.Species,
			SizeCategory: pet.SizeCategory,
		})
	}

	return &petDTOs, nil
}

// UpdatePet updates a pet's details
func (s *PetServiceImpl) UpdatePet(id uint, petDTO model.PetDTO) (*model.PetDTO, error) {
	var pet model.Pet
	err := s.db.First(&pet, id).Error
	if err != nil {
		return nil, err
	}

	if err := os.Remove(helper.GetFilePath(pet.ImageUrl)); err != nil {
		return nil, err
	}

	pet.Name = petDTO.Name
	pet.ImageUrl = petDTO.ImageUrl
	pet.Status = petDTO.Status
	pet.SpeciesID = petDTO.Species.ID
	pet.SizeID = petDTO.SizeCategory.ID

	err = s.db.Save(&pet).Error
	if err != nil {
		return nil, err
	}

	s.db.Preload("Species").Preload("SizeCategory").First(&pet, id)

	petDTOUpdated := model.PetDTO{
		ID:           pet.ID,
		Name:         pet.Name,
		ImageUrl:     pet.ImageUrl,
		Status:       pet.Status,
		Species:      pet.Species,
		SizeCategory: pet.SizeCategory,
	}

	return &petDTOUpdated, nil
}

func (s *PetServiceImpl) CreatePet(ownerID uint, req model.PetRequest) (*model.PetDTO, error) {
	pet := model.Pet{
		Name:      req.Name,
		ImageUrl:  req.ImageUrl,
		OwnerID:   ownerID,
		SpeciesID: req.SpeciesID,
		SizeID:    req.SizeCategoryID,
	}

	if err := s.db.Create(&pet).Error; err != nil {
		return nil, err
	}

	s.db.Preload("Species").Preload("SizeCategory").First(&pet, pet.ID)

	petDTO := model.PetDTO{
		ID:           pet.ID,
		Name:         pet.Name,
		ImageUrl:     pet.ImageUrl,
		Status:       pet.Status,
		Species:      pet.Species,
		SizeCategory: pet.SizeCategory,
	}

	return &petDTO, nil
}

// DeletePet deletes a pet by ID
func (s *PetServiceImpl) DeletePet(id uint) error {
	var pet model.Pet
	if err := s.db.First(&pet, id).Error; err != nil {
		return err
	}

	if err := os.Remove(helper.GetFilePath(pet.ImageUrl)); err != nil {
		return err
	}

	if err := s.db.Unscoped().Delete(&model.Pet{}, id).Error; err != nil {
		return err
	}
	return nil
}
