package model

import "gorm.io/gorm"

type ChatRoom struct {
	gorm.Model
	User1ID       uint `gorm:"index:user_idx"`
	User2ID       uint `gorm:"index:user_idx"`
	LastMessageID *uint

	LastMessage ChatMessage `gorm:"foreignKey:LastMessageID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}
