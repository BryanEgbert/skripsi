package model

import "time"

type Transaction struct {
	ID           uint       `gorm:"primarykey"`
	CreatedAt    time.Time  `gorm:"default:current_timestamp"`
	PetDaycareID uint       `gorm:"not null"`
	BookedSlotID uint       `gorm:"not null"`
	Status       string     `gorm:"default:pending"`
	PetDaycare   PetDaycare `gorm:"foreignKey:PetDaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	BookedSlot   BookedSlot `gorm:"foreignKey:BookedSlotID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}
