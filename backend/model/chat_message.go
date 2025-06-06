package model

import (
	"gorm.io/gorm"
)

type ChatMessage struct {
	gorm.Model
	SenderID   uint   `gorm:"not null"`
	ReceiverID uint   `gorm:"not null"`
	Message    string `gorm:"not null"`
	ImageURL   *string
	IsRead     bool `gorm:"default:0"`

	SenderUser   User `gorm:"foreignKey:SenderID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	ReceiverUser User `gorm:"foreignKey:ReceiverID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

type ChatMessageDTO struct {
	ID           uint    `json:"id"`
	SenderID     uint    `json:"senderId"`
	ReceiverID   uint    `json:"receiverId"`
	Message      string  `json:"message"`
	ErrorMessage *string `json:"errorMessage"`
	ImageURL     *string `json:"imageUrl"`
	IsRead       bool    `json:"isRead"`
	CreatedAt    string  `json:"createdAt"`
}

type SendMessage struct {
	UpdateRead bool    `json:"updateRead"`
	ReceiverID uint    `json:"receiverId"`
	Message    string  `json:"message"`
	ImageURL   *string `json:"imageUrl"`
}
