package model

import (
	"mime/multipart"

	"gorm.io/gorm"
)

type Pet struct {
	gorm.Model
	Name           string `gorm:"not null"`
	ImageUrl       *string
	Status         string          `gorm:"default:'idle'"`
	Neutered       bool            `gorm:"not null"`
	OwnerID        uint            `gorm:"not null"`
	Owner          User            `gorm:"foreignKey:OwnerID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	PetCategoryID  uint            `gorm:"not null"`
	PetCategory    PetCategory     `gorm:"foreignKey:PetCategoryID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	BookedSlots    []BookedSlot    `gorm:"many2many:pet_booked_slots;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many with BookedSlot
	VaccineRecords []VaccineRecord `gorm:"foreignKey:PetID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

type PetDTO struct {
	ID           uint           `json:"id"`
	Name         string         `json:"name"`
	ImageUrl     string         `json:"imageUrl"`
	Status       string         `json:"status"`
	Neutered     bool           `json:"neutered"`
	Owner        UserDTO        `json:"owner"`
	PetCategory  PetCategoryDTO `json:"petCategory"`
	IsVaccinated bool           `json:"isVaccinated"`
	IsBooked     bool           `json:"isBooked"`
}

type GetBookedPetsResponse struct {
	Data []PetDTO `json:"data"`
}

type PetRequest struct {
	Name          string                `form:"petName" binding:"required"`
	PetImage      *multipart.FileHeader `form:"petProfilePicture"`
	Status        string                `form:"status"`
	Neutered      bool                  `form:"neutered"`
	PetCategoryID uint                  `form:"petCategoryId" binding:"required"`
	PetImageUrl   *string
}

type PetAndVaccinationRecordRequest struct {
	PetRequest
	CreateVaccineRecordRequest
}
