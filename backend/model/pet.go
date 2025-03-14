package model

import (
	"mime/multipart"

	"gorm.io/gorm"
)

type Pet struct {
	gorm.Model
	Name         string `gorm:"not null"`
	ImageUrl     *string
	Status       string       `gorm:"default:'idle'"`
	OwnerID      uint         `gorm:"not null"`
	Owner        User         `gorm:"foreignKey:OwnerID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	PetCategoryID    uint         `gorm:"not null"`
	PetCategory      PetCategory      `gorm:"foreignKey:PetCategoryID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	BookedSlots  []BookedSlot `gorm:"foreignKey:PetID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many with BookedSlot
}

type PetDTO struct {
	ID           uint         `json:"id"`
	Name         string       `json:"name"`
	ImageUrl     string       `json:"imageUrl"`
	Status       string       `json:"status"`
	Owner        UserDTO      `json:"owner"`
	PetCategory      PetCategoryDTO      `json:"petCategory"`
}

type GetBookedPetsResponse struct {
	Data []PetDTO `json:"data"`
}

type PetRequest struct {
	Name           string                `form:"name" binding:"required"`
	Image          *multipart.FileHeader `form:"image"`
	Status         string                `form:"status"`
	PetCategoryID uint                  `form:"petCategoryId" binding:"required"`
	ImageUrl       string
}
