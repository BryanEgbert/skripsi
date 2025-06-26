package model

import "time"

type BookedSlotsDaily struct {
	ID        uint      `gorm:"primaryKey"`
	SlotID    uint      `gorm:"not null"`
	Date      time.Time `gorm:"not null;index"`
	SlotCount int       `gorm:"default:1"`
}

type BookedSlotsDailyDTO struct {
	Date      time.Time
	SlotCount int
}
