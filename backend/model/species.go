package model

type Species struct {
	ID   uint   `gorm:"primarykey" json:"id"`
	Name string `gorm:"unique;not null" json:"name"`
	// Pets  []Pet   `gorm:"references:SpeciesID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	// Slots []Slots `gorm:"references:SpeciesID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}
