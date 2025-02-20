package model

import (
	"time"

	"gorm.io/gorm"
)

type BookedSlot struct {
	gorm.Model
	UserID    uint      `gorm:"not null"`
	DaycareID uint      `gorm:"not null"`
	PetID     uint      `gorm:"not null,unique"`
	StartDate time.Time `gorm:"not null"`
	EndDate   time.Time `gorm:"not null"`

	User    User       `gorm:"foreignKey:UserID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	Pet     Pet        `gorm:"foreignKey:PetID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	Daycare PetDaycare `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

type BookSlotRequest struct {
	PetID     uint      `json:"petId" binding:"required"`
	StartDate time.Time `json:"startDate" binding:"required"`
	EndDate   time.Time `json:"endDate" binding:"required"`
	DaycareID uint
}
