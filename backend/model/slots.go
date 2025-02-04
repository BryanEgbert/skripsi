package model

import "gorm.io/gorm"

type Slots struct {
	gorm.Model
	DaycareID uint `gorm:"not null"`
	// Daycare        PetDaycare   `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	SpeciesID uint `gorm:"not null"`
	// Species        Species      `gorm:"foreignKey:SpeciesID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	SizeCategoryID uint `gorm:"not null"`
	// Size           SizeCategory `gorm:"foreignKey:SizeID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	MaxNumber int
}
