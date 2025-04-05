package model

import (
	"mime/multipart"

	"gorm.io/gorm"
)

type VaccineRecord struct {
	gorm.Model
	DateAdministered string `gorm:"type:date"`
	NextDueDate      string `gorm:"type:date"`
	ImageURL         string `gorm:"not null"`
	PetID            uint   `gorm:"not null"`

	Pet Pet `gorm:"foreignKey:PetID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

type VaccineRecordDTO struct {
	ID               uint   `json:"id"`
	DateAdministered string `json:"dateAdministered"`
	NextDueDate      string `json:"nextDueDate"`
	ImageURL         string `json:"imageUrl"`
}

type VaccineRecordRequest struct {
	DateAdministered      string                `form:"dateAdministered" binding:"required"`
	NextDueDate           string                `form:"nextDueDate" binding:"required"`
	VaccineRecordImage    *multipart.FileHeader `form:"vaccineRecordImage" binding:"required"`
	VaccineRecordImageUrl string
}
