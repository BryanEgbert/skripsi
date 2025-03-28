package model

import (
	"mime/multipart"

	"gorm.io/gorm"
)

type VaccineRecord struct {
	gorm.Model
	DateAdministered string `gorm:"type:date"`
	NextDueDate string `gorm:"type:date"`
	ImageURL string `gorm:"not null"`
	PetID uint `gorm:"not null"`

	Pet Pet `gorm:"foreignKey:PetID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

type VaccineRecordRequest struct {
	DateAdministered string `form:"dateAdministered"`
	NextDueDate string `form:"nextDueDate"`
	VaccineRecordImage *multipart.FileHeader `form:"vaccineRecordImage"`
	VaccineRecordImageUrl string
}