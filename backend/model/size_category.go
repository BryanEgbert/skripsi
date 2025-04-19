package model

type SizeCategory struct {
	ID        uint     `gorm:"primarykey" json:"id"`
	Name      string   `gorm:"not null" json:"name"`
	MinWeight float32  `gorm:"not null" json:"minWeight"`
	MaxWeight *float32 `json:"maxWeight"`
}
