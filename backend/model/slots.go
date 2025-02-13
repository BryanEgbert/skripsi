package model

import (
	"gorm.io/gorm"
)

type Slots struct {
	gorm.Model
	DaycareID      uint `gorm:"not null"`
	SpeciesID      uint `gorm:"not null"`
	SizeCategoryID uint `gorm:"not null"`
	MaxNumber      int
}

type GetSlotRequest struct {
	SpeciesID      uint
	SizeCategoryID uint
	Month          int
	Year           int
}

type SlotsResponse struct {
	Date       string `json:"date"`
	SlotAmount int    `json:"slotAmount"`
}
