package model

import "gorm.io/gorm"

type Species struct {
	gorm.Model
	Name string `gorm:"unique;not null"`
	// Pets  []Pet   `gorm:"references:SpeciesID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	// Slots []Slots `gorm:"references:SpeciesID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}
