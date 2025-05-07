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
}

type ChatMessageDTO struct {
	ID           uint    `json:"id"`
	Type         string  `json:"type"`
	SenderID     uint    `json:"senderId"`
	ReceiverID   uint    `json:"receiverId"`
	Message      string  `json:"message"`
	ErrorMessage *string `json:"errorMessage"`
	ImageURL     *string `json:"imageUrl"`
	IsRead       bool    `json:"isRead"`
	CreatedAt    string  `json:"createdAt"`
}

type SendMessage struct {
	ReceiverID uint    `json:"receiverId"`
	Message    string  `json:"message"`
	ImageURL   *string `json:"imageUrl"`
}
