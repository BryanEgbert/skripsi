package model

import (
	"gorm.io/gorm"
)

type Slots struct {
	gorm.Model
	DaycareID     uint    `gorm:"not null"`
	PetCategoryID uint    `gorm:"not null"`
	Price         float64 `gorm:"not null"`
	PricingTypeID uint    `gorm:"not null,default:1"`
	MaxNumber     int

	PetCategory PetCategory `gorm:"foreignKey:PetCategoryID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	PricingType PricingType `gorm:"foreignKey:PricingTypeID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

type GetSlotRequest struct {
	PetCategoryID []uint
}

type SlotsResponse struct {
	Date       string `json:"date"`
	SlotAmount int    `json:"slotAmount"`
}
