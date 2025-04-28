package service

import (
	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type TransactionService interface {
	GetTransactions(userId uint, page int, pageSize int) (*[]model.TransactionDTO, error)
}

type TransactionServiceImpl struct {
	db *gorm.DB
}

func NewTransactionService(db *gorm.DB) *TransactionServiceImpl {
	return &TransactionServiceImpl{db: db}
}

func (s *TransactionServiceImpl) GetTransactions(userId uint, page int, pageSize int) (*[]model.TransactionDTO, error) {
	var transactions []model.Transaction

	if err := s.db.
		Model(&model.Transaction{UserID: userId}).
		Preload("PetDaycare").
		Preload("PetDaycare.Slots").
		Preload("PetDaycare.Slots.PetCategory").
		Preload("PetDaycare.Slots.PetCategory.SizeCategory").
		Preload("BookedSlot").
		Preload("BookedSlot.Status").
		Preload("BookedSlot.Pet").
		Preload("BookedSlot.Pet.PetCategory").
		Preload("BookedSlot.Address").
		Offset((page - 1) * pageSize).
		Limit(pageSize).
		Find(&transactions).Error; err != nil {
		return nil, err
	}

	out := helper.ConvertTransactionsToTransactionDTO(transactions)

	return &out, nil
}
