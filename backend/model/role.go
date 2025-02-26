package model

type Role struct {
	ID    uint   `gorm:"primarykey" json:"id"`
	Name  string `gorm:"unique;not null" json:"name"`
}
