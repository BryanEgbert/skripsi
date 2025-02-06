package model

import (
	"time"

	"gorm.io/gorm"
)

type RefreshToken struct {
	gorm.Model
	UserID    uint      `gorm:"not null;index"`
	Token     string    `gorm:"unique;not null"`
	ExpiresAt time.Time `gorm:"not null"`
}

type RefreshTokenRequest struct {
	RefreshToken string `json:"refreshToken"`
}
