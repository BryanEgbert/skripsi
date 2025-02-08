package model

import "time"

type ReduceSlots struct {
	ID           uint      `gorm:"primaryKey"`
	SlotID       uint      `gorm:"not null"`
	ReducedCount uint      `gorm:"default:0"`
	TargetDate   time.Time `gorm:"not null"`
}

type ReduceSlotsRequest struct {
	SlotID       uint      `json:"slotId"`
	ReducedCount uint      `json:"reducedCount"`
	TargetDate   time.Time `json:"targetDate"`
}
