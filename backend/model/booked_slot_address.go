package model

import "gorm.io/gorm"

type BookedSlotAddress struct {
	gorm.Model
	Name      string  `gorm:"not null" json:"name"`
	Address   string  `gorm:"not null" json:"address"`
	Latitude  float64 `gorm:"not null" json:"latitude"`
	Longitude float64 `gorm:"not null" json:"longitude"`
	Notes     *string `gorm:"default:null" json:"notes"`
}

type BookedSlotAddressDTO struct {
	ID        uint    `json:"id"`
	Name      string  `json:"name"`
	Address   string  `json:"address"`
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
	Notes     *string `json:"notes"`
}
