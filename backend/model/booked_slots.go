package model

import (
	"time"

	"gorm.io/gorm"
)

type BookedSlot struct {
	gorm.Model
	DaycareID int64      `gorm:"not null"`
	Daycare   PetDaycare `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	PetID     int64      `gorm:"not null"`
	Pet       Pet        `gorm:"foreignKey:PetID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	StartDate time.Time
	EndDate   time.Time
}
