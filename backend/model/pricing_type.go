package model

type PricingType struct {
	ID   uint   `gorm:"primarykey" json:"id"`
	Name string `gorm:"not null" json:"name"`
}
