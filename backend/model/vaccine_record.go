package model

import (
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
	DateAdministered string `form:"dateAdministered"`
	NextDueDate      string `form:"nextDueDate"`
	// VaccineRecordImage    *multipart.FileHeader `form:"vaccineRecordImage"`
	VaccineRecordImageUrl string
}

type CreateVaccineRecordRequest struct {
	DateAdministered *string `form:"dateAdministered"`
	NextDueDate      *string `form:"nextDueDate"`
	// VaccineRecordImage    *multipart.FileHeader `form:"vaccineRecordImage"`
	VaccineRecordImageUrl string
}
