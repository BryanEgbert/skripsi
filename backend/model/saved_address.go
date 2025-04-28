package model

import "gorm.io/gorm"

type SavedAddress struct {
	gorm.Model
	Name      string  `gorm:"not null"`
	UserID    uint    `gorm:"not null"`
	Address   string  `gorm:"not null"`
	Latitude  float64 `gorm:"not null"`
	Longitude float64 `gorm:"not null"`
}

type SavedAddressDTO struct {
	ID      uint   `json:"id"`
	Name    string `json:"name"`
	Address string `json:"address"`
}

type CreateSavedAddress struct {
	UserID    uint
	Name      string  `json:"name"`
	Address   string  `json:"address"`
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
}
