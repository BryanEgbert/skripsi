package model

import "gorm.io/gorm"

type Pet struct {
	gorm.Model
	Name         string `gorm:"not null"`
	ImageUrl     string
	Status       string       `gorm:"not null"`
	OwnerID      uint         `gorm:"not null"`
	Owner        User         `gorm:"foreignKey:OwnerID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	SpeciesID    uint         `gorm:"not null"`
	Species      Species      `gorm:"foreignKey:SpeciesID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	SizeID       uint         `gorm:"not null"`
	SizeCategory SizeCategory `gorm:"foreignKey:SizeID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	BookedSlots  []BookedSlot `gorm:"foreignKey:PetID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many with BookedSlot
}

type PetDTO struct {
	ID           uint
	Name         string
	ImageUrl     string
	Status       string
	Species      Species
	SizeCategory SizeCategory
}
