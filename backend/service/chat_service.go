package service

import (
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type ChatService interface {
	InsertMessage(msg *model.ChatMessage) (uint, error)
}

type ChatServiceImpl struct {
	db *gorm.DB
}

func NewChatService(db *gorm.DB) *ChatServiceImpl {
	return &ChatServiceImpl{db: db}
}

func (c *ChatServiceImpl) InsertMessage(msg *model.ChatMessage) (uint, error) {
	if err := c.db.Create(msg).Error; err != nil {
		return 0, err
	}

	return msg.ID, nil
}
