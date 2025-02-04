package model

import "gorm.io/gorm"

type VetSpecialty struct {
	gorm.Model
	Name string `gorm:"unique;not null"`
	// Users []User `gorm:"references:VetSpecialtyID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
}
