package service

import (
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type PetService interface {
	GetPet(id int64) (*model.PetDTO, error)
	GetPets(startID int64, pageSize int) (*[]model.PetDTO, error)
	UpdatePet(id int64, pet model.PetDTO) (*model.PetDTO, error)
	DeletePet(id int64) error
}

type PetServiceImpl struct {
	db *gorm.DB
}

func NewPetService(db *gorm.DB) PetService {
	return &PetServiceImpl{db: db}
}

// GetPet fetches a single pet by ID, joining with Species and SizeCategory
func (s *PetServiceImpl) GetPet(id int64) (*model.PetDTO, error) {
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
func (s *PetServiceImpl) GetPets(startID int64, pageSize int) (*[]model.PetDTO, error) {
	var pets []model.Pet
	query := s.db.Preload("Species").Preload("SizeCategory").Order("id ASC").Limit(pageSize)

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
func (s *PetServiceImpl) UpdatePet(id int64, petDTO model.PetDTO) (*model.PetDTO, error) {
	var pet model.Pet
	err := s.db.First(&pet, id).Error
	if err != nil {
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

	// Reload pet with joined tables
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

// DeletePet deletes a pet by ID
func (s *PetServiceImpl) DeletePet(id int64) error {
	err := s.db.Delete(&model.Pet{}, id).Error
	if err != nil {
		return err
	}
	return nil
}
