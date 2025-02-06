package model

type VetSpecialty struct {
	ID   uint   `gorm:"primarykey" json:"id"`
	Name string `gorm:"unique;not null" json:"name"`
}
