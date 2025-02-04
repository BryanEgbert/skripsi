package model

import (
	"time"

	"gorm.io/gorm"
)

type BookedSlot struct {
	gorm.Model
	DaycareID uint       `gorm:"not null"`
	Daycare   PetDaycare `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	PetID     uint       `gorm:"not null"`
	Pet       Pet        `gorm:"foreignKey:PetID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	StartDate time.Time
	EndDate   time.Time
}
