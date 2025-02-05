package model

import (
	"time"

	"gorm.io/gorm"
)

type PetDaycare struct {
	gorm.Model
	Name              string  `gorm:"not null"`
	Address           string  `gorm:"not null"`
	Latitude          float64 `gorm:"not null"`
	Longitude         float64 `gorm:"not null"`
	Description       string
	BookedNum         int64 `gorm:"default:0"`
	OwnerID           uint  `gorm:"unique;not null"` // One-to-One with User
	Owner             User  `gorm:"foreignKey:OwnerID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	HasPickupService  bool
	MustBeVaccinated  bool
	GroomingAvailable bool
	FoodProvided      bool
	FoodBrand         *string
	CreatedAt         time.Time
	UpdatedAt         *time.Time
	DailyWalksID      uint
	DailyPlaytimeID   uint

	DailyWalks    DailyWalks    `gorm:"foreignKey:DailyWalksID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;" json:"daily_walks"`
	DailyPlaytime DailyPlaytime `gorm:"foreignKey:DailyPlaytimeID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;" json:"daily_playtime"`
	Reviews       []Reviews     `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many
	Slots         []Slots       `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many
	BookedSlots   []BookedSlot  `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many
	Thumbnails    []Thumbnail   `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many
}

type PetDaycareDTO struct {
	ID                uint          `json:"id"`
	Name              string        `json:"name"`
	Address           string        `json:"address"`
	Description       string        `json:"description"`
	BookedNum         int64         `json:"bookedNum"`
	OwnerID           uint          `json:"ownerId"`
	HasPickupService  bool          `json:"hasPickupService"`
	MustBeVaccinated  bool          `json:"mustBeVaccinated"`
	GroomingAvailable bool          `json:"groomingAvailable"`
	FoodProvided      bool          `json:"foodProvided"`
	FoodBrand         *string       `json:"foodBrand"`
	CreatedAt         time.Time     `json:"createdAt"`
	UpdatedAt         *time.Time    `json:"updatedAt"`
	DailyWalks        DailyWalks    `json:"dailyWalks"`
	DailyPlaytime     DailyPlaytime `json:"dailyPlaytime"`
	ThumbnailURLs     []string      `json:"thumbnailUrls"`
}

// CreatePetDaycareRequest represents the request payload
type CreatePetDaycareRequest struct {
	Name              string      `json:"name" binding:"required"`
	Address           string      `json:"address" binding:"required"`
	Description       string      `json:"description"`
	HasPickupService  bool        `json:"hasPickupService"`
	MustBeVaccinated  bool        `json:"mustBeVaccinated"`
	GroomingAvailable bool        `json:"groomingAvailable"`
	FoodProvided      bool        `json:"foodProvided"`
	FoodBrand         *string     `json:"foodBrand,omitempty"`
	DailyWalksID      uint        `json:"dailyWalksId"`
	DailyPlaytimeID   uint        `json:"dailyPlaytimeId"`
	Slots             []SlotInput `json:"slots" binding:"required"`
}

// SlotInput represents each slot entry in the request
type SlotInput struct {
	SpeciesID      uint `json:"speciesId" binding:"required"`
	SizeCategoryID uint `json:"sizeCategoryId" binding:"required"`
	MaxNumber      int  `json:"maxNumber" binding:"required"`
}
