package service

import (
	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type TransactionService interface {
	GetTransaction(id uint, userId uint) (*model.TransactionDTO, error)
	GetTransactions(userId uint, page int, pageSize int) (*[]model.TransactionDTO, error)
}

type TransactionServiceImpl struct {
	db *gorm.DB
}

func NewTransactionService(db *gorm.DB) *TransactionServiceImpl {
	return &TransactionServiceImpl{db: db}
}

func (s *TransactionServiceImpl) GetTransaction(id uint, userId uint) (*model.TransactionDTO, error) {
	var transaction model.Transaction

	if err := s.db.
		Model(&model.Transaction{ID: id, UserID: userId}).
		Preload("BookedSlot").
		Preload("BookedSlot.User").
		Preload("BookedSlot.Status").
		Preload("BookedSlot.Pet").
		Preload("BookedSlot.Pet.PetCategory").
		Preload("BookedSlot.Pet.PetCategory.SizeCategory").
		Preload("BookedSlot.Address").
		Preload("BookedSlot.Daycare").
		Preload("BookedSlot.Daycare.Slots").
		Preload("BookedSlot.Daycare.Slots.PricingType").
		Preload("BookedSlot.Daycare.Slots.PetCategory").
		Preload("BookedSlot.Daycare.Slots.PetCategory.SizeCategory").
		Where("id = ? AND user_id = ?", id, userId).
		Find(&transaction).Error; err != nil {
		return nil, err
	}

	out := helper.ConvertTransactionToTransactionDTO(transaction)

	return &out, nil
}

func (s *TransactionServiceImpl) GetTransactions(userId uint, page int, pageSize int) (*[]model.TransactionDTO, error) {
	var transactions []model.Transaction

	if err := s.db.
		Model(&model.Transaction{}).
		Preload("BookedSlot").
		Preload("BookedSlot.User").
		Preload("BookedSlot.Status").
		Preload("BookedSlot.Pet").
		Preload("BookedSlot.Pet.PetCategory").
		Preload("BookedSlot.Pet.PetCategory.SizeCategory").
		Preload("BookedSlot.Address").
		Preload("BookedSlot.Daycare").
		Preload("BookedSlot.Daycare.Slots").
		Preload("BookedSlot.Daycare.Slots.PricingType").
		Preload("BookedSlot.Daycare.Slots.PetCategory").
		Preload("BookedSlot.Daycare.Slots.PetCategory.SizeCategory").
		Where("user_id = ?", userId).
		Offset((page - 1) * pageSize).
		Limit(pageSize).
		Find(&transactions).Error; err != nil {
		return nil, err
	}

	out := helper.ConvertTransactionsToTransactionDTO(transactions)

	return &out, nil
}
