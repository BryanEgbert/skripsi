package model

import "gorm.io/gorm"

type SizeCategory struct {
	gorm.Model
	Name      string  `gorm:"not null"`
	MinWeight float32 `gorm:"not null"`
	MaxWeight float32 `gorm:"not null"`
	// Pets      []Pet   `gorm:"foreignKey:SizeID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	// Slots     []Slots `gorm:"foreignKey:SizeID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}
