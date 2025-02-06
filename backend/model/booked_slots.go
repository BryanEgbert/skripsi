package model

import (
	"time"

	"gorm.io/gorm"
)

type BookedSlot struct {
	gorm.Model
	DaycareID uint      `gorm:"not null"`
	PetID     uint      `gorm:"not null"`
	StartDate time.Time `gorm:"not null"`
	EndDate   time.Time `gorm:"not null"`

	Pet     Pet        `gorm:"foreignKey:PetID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	Daycare PetDaycare `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}
