package service

import (
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type TransactionService interface {
	GetTransactions(userId uint, startId uint, pageSize int) (*[]model.TransactionDTO, error)
}

type TransactionServiceImpl struct {
	db *gorm.DB
}

func NewTransactionService(db *gorm.DB) *TransactionServiceImpl {
	return &TransactionServiceImpl{db: db}
}

func (s *TransactionServiceImpl) GetTransactions(userId uint, startId uint, pageSize int) (*[]model.TransactionDTO, error) {
	var transactions []model.TransactionDTO

	if err := s.db.
		Model(&model.Transaction{}).
		Joins("PetDaycare").
		Joins("BookedSlot").
		Where("user_id = ? AND id > ?", userId, startId).
		Limit(pageSize).
		Find(&transactions).Error; err != nil {
		return nil, err
	}

	return &transactions, nil
}
