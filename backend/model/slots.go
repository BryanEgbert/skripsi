package model

import (
	"gorm.io/gorm"
)

type Slots struct {
	gorm.Model
	DaycareID      uint `gorm:"not null"`
	PetCategoryID      uint `gorm:"not null"`
	Price             float64 `gorm:"not null"`
	PricingType       string  `gorm:"default:'day'"`
	MaxNumber      int
	
	PetCategory      PetCategory      `gorm:"foreignKey:PetCategoryID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

type GetSlotRequest struct {
	PetCategoryID      uint
	Month          int
	Year           int
}

type SlotsResponse struct {
	Date       string `json:"date"`
	SlotAmount int    `json:"slotAmount"`
}
