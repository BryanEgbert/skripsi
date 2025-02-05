package model

type VetSpecialty struct {
	ID   uint   `gorm:"primarykey" json:"id"`
	Name string `gorm:"unique;not null" json:"name"`
	// Users []User `gorm:"references:VetSpecialtyID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
}
