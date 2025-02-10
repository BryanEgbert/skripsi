package service

import (
	"errors"

	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type SlotService interface {
	BookSlots(userId uint, req model.BookSlotRequest) error
	EditSlotCount(userId uint, req model.ReduceSlotsRequest) error
}

type SlotServiceImpl struct {
	db *gorm.DB
}

func NewSlotService(db *gorm.DB) *SlotServiceImpl {
	return &SlotServiceImpl{db: db}
}

func (s *SlotServiceImpl) EditSlotCount(userId uint, req model.ReduceSlotsRequest) error {
	slot := model.ReduceSlots{
		SlotID:     req.SlotID,
		TargetDate: req.TargetDate,
	}

	if err := s.db.
		Model(&slot).
		UpdateColumn("reduced_count", gorm.Expr("reduced_count - ?", req.ReducedCount)).
		Error; err != nil {
		return err
	}

	return nil
}

func (s *SlotServiceImpl) BookSlots(userId uint, req model.BookSlotRequest) error {
	var speciesId uint
	if err := s.db.
		Table("pet").
		Select("species_id").
		Where("id = ?", req.PetID).
		Scan(&speciesId).
		Error; err != nil {
		return err
	}

	slot := model.Slots{
		SpeciesID: speciesId,
		DaycareID: req.DaycareID,
	}
	if err := s.db.First(&slot).Error; err != nil {
		return err
	}

	var bookedSlotsCount int64
	var reducedSlotsCount int64

	if err := s.db.
		Model(&model.ReduceSlots{}).
		Select("SUM(reduced_count)").
		Where("slot_id = ? AND target_date BETWEEN ? AND ?").
		Scan(&reducedSlotsCount).
		Error; err != nil {
		return err
	}

	if err := s.db.
		Model(&model.BookedSlot{
			PetID:     req.PetID,
			DaycareID: req.DaycareID,
			StartDate: req.StartDate,
			EndDate:   req.EndDate,
		}).
		Count(&bookedSlotsCount).
		Error; err != nil {
		return err
	}

	remainingSlots := slot.MaxNumber - int(bookedSlotsCount) - int(reducedSlotsCount)

	if remainingSlots <= 0 {
		return errors.New("Slots are full in between the chosen date")
	}

	newBookSlot := model.BookedSlot{
		UserID:    userId,
		DaycareID: req.DaycareID,
		PetID:     req.PetID,
		StartDate: req.StartDate,
		EndDate:   req.EndDate,
	}

	// if err := s.db.
	// 	Clauses(clause.Returning{}).
	// 	Create(&newBookSlot).Error; err != nil {
	// 	return err
	// }

	newTransaction := model.Transaction{
		PetDaycareID: req.DaycareID,
		BookedSlot:   newBookSlot,
	}

	if err := s.db.Create(&newTransaction).Error; err != nil {
		return err
	}

	return nil
}
