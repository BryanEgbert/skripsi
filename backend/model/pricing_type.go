package model

type PricingType struct {
	ID   uint   `gorm:"primarykey"`
	Name string `gorm:"not null"`
}
