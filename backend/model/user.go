package model

import (
	"time"

	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	Name         string          `gorm:"unique;not null"`
	Email        string          `gorm:"unique;not null"`
	Password     string          `gorm:"not null"`
	ImageUrl     string          `gorm:"default:null"`
	RoleID       uint            `gorm:"not null"`
	Role         Role            `gorm:"foreignKey:RoleID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
	VetSpecialty *[]VetSpecialty `gorm:"default:null;many2many:user_vet_specialties;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	PetDaycare   *PetDaycare     `gorm:"foreignKey:OwnerID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-One relationship
	Pets         []Pet           `gorm:"foreignKey:OwnerID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many relationship
	Reviews      []Reviews       `gorm:"foreignKey:UserID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

type UserDTO struct {
	ID           uint
	Name         string
	Email        string
	ImageUrl     string
	RoleID       uint
	VetSpecialty *[]VetSpecialty
	CreatedAt    time.Time
}

type UpdateUserDTO struct {
	ID             uint    `json:"id"`
	Name           string  `json:"name"`
	Email          string  `json:"email"`
	ImageUrl       string  `json:"imageUrl"`
	RoleID         uint    `json:"roleId"`
	VetSpecialtyID *[]uint `json:"vetSpecialtyId"`
}
