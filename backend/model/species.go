package model

import "gorm.io/gorm"

type Species struct {
	gorm.Model
	Name  string  `gorm:"unique;not null"`
	Pets  []Pet   `gorm:"foreignKey:SpeciesID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	Slots []Slots `gorm:"foreignKey:SpeciesID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}
