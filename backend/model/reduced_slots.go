package model

import "time"

type ReduceSlots struct {
	ID     uint `gorm:"primaryKey"`
	SlotID uint `gorm:"not null"`
	// DaycareID    uint      `gorm:"not null"`
	ReducedCount uint      `gorm:"default:0"`
	TargetDate   time.Time `gorm:"not null"`

	// PetDaycare PetDaycare `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

type ReduceSlotsRequest struct {
	ReducedCount uint      `json:"reducedCount"`
	TargetDate   time.Time `json:"targetDate"`
}

type ReduceSlotsDTO struct {
	ID     uint `json:"id"`
	SlotID uint `json:"slotId"`
	// DaycareID    uint   `json:"daycareId"`
	ReducedCount uint   `json:"reducedCount"`
	TargetDate   string `json:"targetDate"`
}
