package model

type Thumbnail struct {
	ID        uint   `gorm:"primarykey" json:"id"`
	DaycareID uint   `gorm:"not null" json:"daycareId"`
	ImageUrl  string `gorm:"not null" json:"imageUrl"`
}
