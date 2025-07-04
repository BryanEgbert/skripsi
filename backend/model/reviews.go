package model

import "gorm.io/gorm"

type Reviews struct {
	gorm.Model
	DaycareID   uint       `gorm:"not null"`
	Daycare     PetDaycare `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	UserID      uint       `gorm:"not null"`
	User        User       `gorm:"foreignKey:UserID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	Rate        int
	Description string
}

type CreateReviewRequest struct {
	Rating      int    `json:"rating"`
	Description string `json:"description"`
}

type ReviewsDTO struct {
	ID          uint    `json:"id"`
	Rating      int     `json:"rating"`
	Description string  `json:"description"`
	User        UserDTO `json:"user"`
	CreatedAt   string  `json:"createdAt"`
}
