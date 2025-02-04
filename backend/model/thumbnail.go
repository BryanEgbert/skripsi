package model

import "gorm.io/gorm"

type Thumbnail struct {
	gorm.Model
	DaycareID uint `gorm:"not null"`
	// Daycare   PetDaycare `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	ImageUrl string `gorm:"not null"`
}
