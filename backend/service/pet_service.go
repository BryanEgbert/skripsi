package service

import (
	"os"

	apputils "github.com/BryanEgbert/skripsi/app_utils"
	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type PetService interface {
	GetPet(id uint) (*model.PetDTO, error)
	GetPets(ownerID uint, startID uint, pageSize int) (*[]model.PetDTO, error)
	GetBookedPets(userId uint, startID uint, pageSize int) (*[]model.PetDTO, error)
	CreatePet(ownerID uint, req model.PetRequest) (uint, error)
	UpdatePet(id uint, pet model.PetDTO) error
	DeletePet(id uint, userId uint) error
}

type PetServiceImpl struct {
	db *gorm.DB
}

func NewPetService(db *gorm.DB) *PetServiceImpl {
	return &PetServiceImpl{db: db}
}

func (s *PetServiceImpl) GetBookedPets(userId uint, startID uint, pageSize int) (*[]model.PetDTO, error) {
	petDtos := []model.PetDTO{}

	// TODO: add condition when status is confirmed
	rows, err := s.db.
		Table("pets").
		Select("pets.id, pets.name, pets.image_url, pets.status,pet_categories.id, pet_categories.name, size_categories.*, users.id, users.name, users.email, users.image_url, roles.id, roles.name, users.created_at").
		Joins("JOIN pet_booked_slots on pet_booked_slots.pet_id = pets.id").
		Joins("JOIN booked_slots on pet_booked_slots.booked_slot_id = booked_slots.id").
		Joins("JOIN pet_categories ON pet_categories.id = pets.pet_category_id").
		Joins("JOIN size_categories ON size_categories.id = pet_categories.size_category_id").
		Joins("JOIN pet_daycares ON pet_daycares.id = booked_slots.daycare_id").
		Joins("JOIN users ON users.id = pets.owner_id").
		Joins("JOIN roles ON roles.id = users.role_id").
		Where("pets.id > ? AND pet_daycares.owner_id = ? AND booked_slots.status_id = 2", startID, userId).
		Limit(pageSize).Rows()
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var petDto model.PetDTO
		var imageUrl *string
		rows.Scan(
			&petDto.ID,
			&petDto.Name,
			&imageUrl,
			&petDto.Status,
			&petDto.PetCategory.ID,
			&petDto.PetCategory.Name,
			&petDto.PetCategory.ID,
			&petDto.PetCategory.Name,
			&petDto.PetCategory.SizeCategory.MinWeight,
			&petDto.PetCategory.SizeCategory.MaxWeight,
			&petDto.Owner.ID,
			&petDto.Owner.Name,
			&petDto.Owner.Email,
			&petDto.Owner.ImageUrl,
			&petDto.Owner.Role.ID,
			&petDto.Owner.Role.Name,
			&petDto.Owner.CreatedAt,
		)

		petDto.Owner.VetSpecialty = []model.VetSpecialty{}

		if imageUrl != nil {
			petDto.ImageUrl = *imageUrl
		}

		petDtos = append(petDtos, petDto)
	}

	// var pets []model.Pet

	// if err := s.db.Model(&model.Pet{}).
	// 	Joins("PetCategory").
	// 	Joins("Owner").
	// 	Joins("Owner.Role").
	// 	Joins("PetCategory.SizeCategory").
	// 	Preload("BookedSlots").
	// 	Preload("BookedSlots.Daycare").
	// 	Where("pets.id > ?", startID).
	// 	Limit(pageSize).
	// 	Find(&pets).Error; err != nil {
	// 	return nil, err
	// }

	// out := []model.PetDTO{}
	// for _, val := range pets {
	// 	for _, bookedSlot := range val.BookedSlots {
	// 		log.Printf("daycareID: %d, statusID: %d", bookedSlot.DaycareID, *bookedSlot.StatusID)
	// 		if bookedSlot.StatusID == nil || bookedSlot.Daycare.OwnerID != userId {
	// 			continue
	// 		}
	// 		if *bookedSlot.StatusID == 2 {
	// 			pet := model.PetDTO{
	// 				ID:          val.ID,
	// 				Name:        val.Name,
	// 				Status:      val.Status,
	// 				Neutered:    val.Neutered,
	// 				Owner:       helper.ConvertUserToDTO(val.Owner),
	// 				PetCategory: helper.ConvertPetCategoryToDTO(val.PetCategory),
	// 			}

	// 			if val.ImageUrl != nil {
	// 				pet.ImageUrl = *val.ImageUrl
	// 			}

	// 			out = append(out, pet)
	// 		}
	// 	}

	// }

	return &petDtos, nil
}

func (s *PetServiceImpl) GetPet(id uint) (*model.PetDTO, error) {
	var pet model.Pet
	if err := s.db.
		// Preload("BookedSlots").
		Preload("VaccineRecords").
		Joins("PetCategory").
		Joins("PetCategory.SizeCategory").
		Joins("Owner").
		Joins("Owner.Role").
		First(&pet, id).Error; err != nil {
		return nil, err
	}

	petDTO := model.PetDTO{
		ID:          pet.ID,
		Name:        pet.Name,
		Status:      pet.Status,
		Neutered:    pet.Neutered,
		PetCategory: helper.ConvertPetCategoryToDTO(pet.PetCategory),
		Owner:       helper.ConvertUserToDTO(pet.Owner),
	}

	if pet.ImageUrl != nil {
		petDTO.ImageUrl = *pet.ImageUrl
	}

	return &petDTO, nil
}

// GetPets implements cursor-based pagination
// GetPets fetches pets owned by a specific user using cursor-based pagination
func (s *PetServiceImpl) GetPets(ownerID uint, startID uint, pageSize int) (*[]model.PetDTO, error) {
	var pets []model.Pet
	query := s.db.
		Joins("PetCategory").
		Joins("PetCategory.SizeCategory").
		Joins("Owner").
		Joins("Owner.Role").
		Preload("VaccineRecords", func(db *gorm.DB) *gorm.DB {
			return db.Order("vaccine_records.next_due_date DESC")
		}).
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
		isVaccinated, err := helper.PetIsVaccinated(pet)
		if err != nil {
			return nil, err
		}

		dto := model.PetDTO{
			ID:           pet.ID,
			Name:         pet.Name,
			Status:       pet.Status,
			Neutered:     pet.Neutered,
			PetCategory:  helper.ConvertPetCategoryToDTO(pet.PetCategory),
			Owner:        helper.ConvertUserToDTO(pet.Owner),
			IsVaccinated: isVaccinated,
		}

		if pet.ImageUrl != nil {
			dto.ImageUrl = *pet.ImageUrl
		}

		petDTOs = append(petDTOs, dto)

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

	if pet.ImageUrl != nil {
		os.Remove(helper.GetFilePath(*pet.ImageUrl))
	}

	pet.Name = petDTO.Name
	pet.Status = petDTO.Status
	pet.PetCategoryID = petDTO.PetCategory.ID
	pet.Neutered = petDTO.Neutered
	if petDTO.ImageUrl != "" {
		pet.ImageUrl = &petDTO.ImageUrl
	}

	err = s.db.Save(&pet).Error
	if err != nil {
		return err
	}

	return nil
}

func (s *PetServiceImpl) CreatePet(ownerID uint, req model.PetRequest) (uint, error) {
	pet := model.Pet{
		Name:          req.Name,
		ImageUrl:      req.PetImageUrl,
		OwnerID:       ownerID,
		PetCategoryID: req.PetCategoryID,
		Neutered:      req.Neutered,
	}

	if err := s.db.
		Clauses(clause.Returning{}).
		Create(&pet).Error; err != nil {
		return 0, err
	}

	return pet.ID, nil
}

// DeletePet deletes a pet by ID
func (s *PetServiceImpl) DeletePet(id uint, userId uint) error {
	petCount := int64(0)
	if err := s.db.Model(&model.Pet{}).
		Where("owner_id = ?", userId).
		Count(&petCount).Error; err != nil {
		return err
	}

	if petCount <= 1 {
		return apputils.ErrOnlyOnePet
	}

	var pet model.Pet
	if err := s.db.First(&pet, id).Error; err != nil {
		return err
	}

	if pet.ImageUrl != nil {
		os.Remove(helper.GetFilePath(*pet.ImageUrl))
	}

	if err := s.db.Unscoped().Delete(&pet).Error; err != nil {
		return err
	}
	return nil
}
