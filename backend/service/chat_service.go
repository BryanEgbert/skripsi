package service

import (
	"time"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type ChatService interface {
	GetMessages(userId1 uint, userId2 uint) (model.ListData[model.ChatMessageDTO], error)
	GetUnreadMessages(userId uint) (model.ListData[model.ChatMessageDTO], error)
	InsertMessage(msg *model.ChatMessage) (uint, error)
	UpdateRead(senderId uint, receiverId uint) error
	GetUserChatList(vetId uint) (model.ListData[model.UserDTO], error)
}

type ChatServiceImpl struct {
	db *gorm.DB
}

func NewChatService(db *gorm.DB) *ChatServiceImpl {
	return &ChatServiceImpl{db: db}
}

func (c *ChatServiceImpl) GetUserChatList(userId uint) (model.ListData[model.UserDTO], error) {
	var message []model.ChatMessage
	out := []model.UserDTO{}

	if err := c.db.
		Model(&model.ChatMessage{}).
		Distinct("sender_id").
		Where("(receiver_id = ? OR sender_id = ?) AND sender_id != ?", userId, userId, userId).
		Joins("SenderUser").
		Joins("SenderUser.Role").
		Find(&message).Error; err != nil {
		return model.ListData[model.UserDTO]{}, err
	}

	for _, val := range message {

		user := helper.ConvertUserToDTO(val.SenderUser)
		out = append(out, user)
	}

	if err := c.db.
		Model(&model.ChatMessage{}).
		Distinct("receiver_id").
		Where("(receiver_id = ? OR sender_id = ?) AND receiver_id != ?", userId, userId, userId).
		Joins("ReceiverUser").
		Joins("ReceiverUser.Role").
		Find(&message).Error; err != nil {
		return model.ListData[model.UserDTO]{}, err
	}

	for _, val := range message {

		user := helper.ConvertUserToDTO(val.ReceiverUser)
		out = append(out, user)
	}

	return model.ListData[model.UserDTO]{Data: out}, nil
}

func (c *ChatServiceImpl) GetUnreadMessages(userId uint) (model.ListData[model.ChatMessageDTO], error) {
	var chatMessages []model.ChatMessage
	chatDTO := []model.ChatMessageDTO{}

	if err := c.db.
		Model(&model.ChatMessage{}).
		Where("receiver_id = ? AND is_read = ?", userId, false).
		Find(&chatMessages).Error; err != nil {
		return model.ListData[model.ChatMessageDTO]{}, err
	}

	for _, val := range chatMessages {
		chatDTO = append(chatDTO, model.ChatMessageDTO{
			ID:         val.ID,
			SenderID:   val.SenderID,
			ReceiverID: val.ReceiverID,
			Message:    val.Message,
			ImageURL:   val.ImageURL,
			IsRead:     val.IsRead,
			CreatedAt:  val.CreatedAt.Format(time.RFC3339),
		})
	}

	return model.ListData[model.ChatMessageDTO]{Data: chatDTO}, nil
}

func (c *ChatServiceImpl) GetMessages(userId1 uint, userId2 uint) (model.ListData[model.ChatMessageDTO], error) {
	var chatMessages []model.ChatMessage
	chatDTO := []model.ChatMessageDTO{}

	if err := c.db.
		Model(&model.ChatMessage{}).
		Where("(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)", userId1, userId2, userId2, userId1).
		Order("id ASC").
		Find(&chatMessages).Error; err != nil {
		return model.ListData[model.ChatMessageDTO]{}, err
	}

	for _, val := range chatMessages {
		chatDTO = append(chatDTO, model.ChatMessageDTO{
			ID:         val.ID,
			SenderID:   val.SenderID,
			ReceiverID: val.ReceiverID,
			Message:    val.Message,
			ImageURL:   val.ImageURL,
			IsRead:     val.IsRead,
			CreatedAt:  val.CreatedAt.Format(time.RFC3339),
		})
	}

	return model.ListData[model.ChatMessageDTO]{Data: chatDTO}, nil
}

func (c *ChatServiceImpl) InsertMessage(msg *model.ChatMessage) (uint, error) {
	if err := c.db.Create(msg).Error; err != nil {
		return 0, err
	}

	return msg.ID, nil
}

func (c *ChatServiceImpl) UpdateRead(senderId uint, receiverId uint) error {
	if err := c.db.Model(&model.ChatMessage{}).Where("sender_id = ? AND receiver_id = ?", senderId, receiverId).UpdateColumn("is_read", true).Error; err != nil {
		return err
	}

	return nil
}
