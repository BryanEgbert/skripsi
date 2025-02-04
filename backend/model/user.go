package model

import (
	"time"

	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	Name           string        `gorm:"not null"`
	Email          string        `gorm:"unique;not null"`
	Password       string        `gorm:"not null"`
	RoleID         uint          `gorm:"not null"`
	Role           Role          `gorm:"foreignKey:RoleID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
	VetSpecialtyID *uint         `gorm:"default:null"`
	VetSpecialty   *VetSpecialty `gorm:"foreignKey:VetSpecialtyID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
	PetDaycare     *PetDaycare   `gorm:"foreignKey:OwnerID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-One relationship
	Pets           []Pet         `gorm:"foreignKey:OwnerID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many relationship
	Reviews        []Reviews     `gorm:"foreignKey:UserID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

type UserDTO struct {
	ID             int64
	Name           string
	Email          string
	RoleID         uint
	VetSpecialtyID *uint
	CreatedAt      time.Time
}
