package model

import (
	"time"

	"gorm.io/gorm"
)

type PetDaycare struct {
	gorm.Model
	Name             string `gorm:"not null"`
	Address          string `gorm:"not null"`
	Description      string
	BookedNum        int64 `gorm:"default:0"`
	OwnerID          uint  `gorm:"unique;not null"` // One-to-One with User
	Owner            User  `gorm:"foreignKey:OwnerID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	HasPickupService bool
	MustBeVaccinated bool
	FoodProvided     bool
	FoodBrand        *string
	CreatedAt        time.Time
	UpdatedAt        *time.Time
	Reviews          []Reviews    `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many
	Slots            []Slots      `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many
	BookedSlots      []BookedSlot `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many
	Thumbnails       []Thumbnail  `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many
}
