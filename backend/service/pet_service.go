package service

import (
	"os"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type PetService interface {
	GetPet(id uint) (*model.PetDTO, error)
	GetPets(ownerID uint, startID uint, pageSize int) (*[]model.PetDTO, error)
	GetBookedPets(userId uint, daycareId uint, startID uint, pageSize int) (*model.GetBookedPetsResponse, error)
	CreatePet(ownerID uint, req model.PetRequest) error
	UpdatePet(id uint, pet model.PetDTO) error
	DeletePet(id uint) error
}

type PetServiceImpl struct {
	db *gorm.DB
}

func NewPetService(db *gorm.DB) *PetServiceImpl {
	return &PetServiceImpl{db: db}
}

func (s *PetServiceImpl) GetBookedPets(userId uint, daycareId uint, startID uint, pageSize int) (*model.GetBookedPetsResponse, error) {
	petDtos := []model.PetDTO{}

	rows, err := s.db.
		Model(&model.Pet{}).
		Select("pets.id,pets.name,pets.image_url,pets.status,species.*, size_categories.*, users.id, users.name, users.email, users.image_url, roles.id, roles.name, users.created_at").
		Joins("JOIN booked_slots on booked_slots.pet_id = pets.id").
		Joins("JOIN species ON species.id = pets.species_id").
		Joins("JOIN size_categories ON size_categories.id = pets.size_id").
		Joins("JOIN pet_daycares ON pet_daycares.id = booked_slots.daycare_id").
		Joins("JOIN users ON users.id = pets.owner_id").
		Joins("JOIN roles ON roles.id = users.role_id").
		Where("booked_slots.daycare_id = ? AND pets.id > ? AND pet_daycares.owner_id = ?", daycareId, startID, userId).
		Limit(pageSize).Rows()
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var petDto model.PetDTO
		rows.Scan(
			&petDto.ID,
			&petDto.Name,
			&petDto.ImageUrl,
			&petDto.Status,
			&petDto.Species.ID,
			&petDto.Species.Name,
			&petDto.SizeCategory.ID,
			&petDto.SizeCategory.Name,
			&petDto.SizeCategory.MinWeight,
			&petDto.SizeCategory.MaxWeight,
			&petDto.Owner.ID,
			&petDto.Owner.Name,
			&petDto.Owner.Email,
			&petDto.Owner.ImageUrl,
			&petDto.Owner.Role.ID,
			&petDto.Owner.Role.Name,
			&petDto.Owner.CreatedAt,
		)
		petDtos = append(petDtos, petDto)
	}

	out := model.GetBookedPetsResponse{
		Data: petDtos,
	}

	return &out, nil
}

// GetPet fetches a single pet by ID, joining with Species and SizeCategory
func (s *PetServiceImpl) GetPet(id uint) (*model.PetDTO, error) {
	var pet model.Pet
	if err := s.db.
		Preload("BookedSlots").
		Joins("Species").
		Joins("SizeCategory").
		Joins("Owner").
		Joins("Owner.Role").
		First(&pet, id).Error; err != nil {
		return nil, err
	}

	petDTO := model.PetDTO{
		ID:           pet.ID,
		Name:         pet.Name,
		ImageUrl:     *pet.ImageUrl,
		Status:       pet.Status,
		Species:      pet.Species,
		SizeCategory: pet.SizeCategory,
		Owner:        helper.ConvertUserToDTO(pet.Owner),
	}

	return &petDTO, nil
}

// GetPets implements cursor-based pagination
// GetPets fetches pets owned by a specific user using cursor-based pagination
func (s *PetServiceImpl) GetPets(ownerID uint, startID uint, pageSize int) (*[]model.PetDTO, error) {
	var pets []model.Pet
	query := s.db.
		Joins("Species").
		Joins("SizeCategory").
		Joins("Owner").
		Joins("Owner.Role").
		Where("owner_id = ?", ownerID).
		Order("id ASC").
		Limit(pageSize)

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
			ImageUrl:     *pet.ImageUrl,
			Status:       pet.Status,
			Species:      pet.Species,
			SizeCategory: pet.SizeCategory,
			Owner:        helper.ConvertUserToDTO(pet.Owner),
		})
	}

	return &petDTOs, nil
}

// UpdatePet updates a pet's details
func (s *PetServiceImpl) UpdatePet(id uint, petDTO model.PetDTO) error {
	var pet model.Pet
	err := s.db.First(&pet, id).Error
	if err != nil {
		return err
	}

	if err := os.Remove(helper.GetFilePath(*pet.ImageUrl)); err != nil {
		return err
	}

	pet.Name = petDTO.Name
	pet.ImageUrl = &petDTO.ImageUrl
	pet.Status = petDTO.Status
	pet.SpeciesID = petDTO.Species.ID
	pet.SizeID = petDTO.SizeCategory.ID

	err = s.db.Save(&pet).Error
	if err != nil {
		return err
	}

	return nil
}

func (s *PetServiceImpl) CreatePet(ownerID uint, req model.PetRequest) error {
	pet := model.Pet{
		Name:      req.Name,
		ImageUrl:  &req.ImageUrl,
		OwnerID:   ownerID,
		SpeciesID: req.SpeciesID,
		SizeID:    req.SizeCategoryID,
	}

	if err := s.db.Create(&pet).Error; err != nil {
		return err
	}

	return nil
}

// DeletePet deletes a pet by ID
func (s *PetServiceImpl) DeletePet(id uint) error {
	var pet model.Pet
	if err := s.db.First(&pet, id).Error; err != nil {
		return err
	}

	if err := os.Remove(helper.GetFilePath(*pet.ImageUrl)); err != nil {
		return err
	}

	if err := s.db.Unscoped().Delete(&model.Pet{}, id).Error; err != nil {
		return err
	}
	return nil
}
