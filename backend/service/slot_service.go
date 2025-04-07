package service

import (
	"errors"
	"fmt"
	"time"

	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type SlotService interface {
	GetSlots(petDaycareId uint, req model.GetSlotRequest) (*[]model.SlotsResponse, error)
	BookSlots(userId uint, req model.BookSlotRequest) error
	EditSlotCount(slotId uint, req model.ReduceSlotsRequest) error
}

type SlotServiceImpl struct {
	db *gorm.DB
}

func NewSlotService(db *gorm.DB) *SlotServiceImpl {
	return &SlotServiceImpl{db: db}
}

func (s *SlotServiceImpl) GetSlots(petDaycareId uint, req model.GetSlotRequest) (*[]model.SlotsResponse, error) {
	firstDay := time.Date(req.Year, time.Month(req.Month), 1, 0, 0, 0, 0, time.Local)
	lastDay := firstDay.AddDate(0, 1, -1)

	slots := model.Slots{
		DaycareID:     petDaycareId,
		PetCategoryID: req.PetCategoryID,
	}

	if err := s.db.First(&slots).Error; err != nil {
		return nil, err
	}

	var reduceSlots []model.ReduceSlots
	if err := s.db.Where("slot_id = ?", slots.ID).Find(&reduceSlots).Error; err != nil {
		return nil, err
	}

	var bookedSlots []model.BookedSlotsDailyDTO
	// if err := s.db.
	// 	Model(&model.BookedSlotsDaily{}).
	// 	Select("date, SUM(slot_count) AS slot_count").
	// 	Where("daycare_id = ? AND date BETWEEN ? AND ?", petDaycareId, firstDay, lastDay).
	// 	Group("date").
	// 	Find(&bookedSlots).Error; err != nil {
	// 	return nil, err
	// }
	rows, err := s.db.
		Model(&model.BookedSlotsDaily{}).
		Select("date, SUM(slot_count) AS slot_count").
		Where("daycare_id = ? AND date BETWEEN ? AND ?", petDaycareId, firstDay, lastDay).
		Group("date").Rows()
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {

		bookedSlot := model.BookedSlotsDailyDTO{}
		s.db.ScanRows(rows, &bookedSlot)
		bookedSlots = append(bookedSlots, bookedSlot)
	}

	fmt.Printf("Booked slots: %+v", bookedSlots)

	reduceSlotsMap := make(map[string]int)
	for _, r := range reduceSlots {
		reduceSlotsMap[r.TargetDate.Format("2006-01-02")] = int(r.ReducedCount)
	}

	bookedSlotsMap := make(map[string]int)
	for _, b := range bookedSlots {
		bookedSlotsMap[b.Date.Format("2006-01-02")] = int(b.SlotCount)
	}

	var out []model.SlotsResponse
	for day := firstDay; !day.After(lastDay); day = day.AddDate(0, 0, 1) {
		dateStr := day.Format("2006-01-02")

		maxSlots := int(slots.MaxNumber)         // Default slots
		reduced := reduceSlotsMap[dateStr]       // Reduced slots
		booked := bookedSlotsMap[dateStr]        // Booked slots
		remaining := maxSlots - reduced - booked // Remaining slots

		out = append(out, model.SlotsResponse{
			Date:       day.Format(time.RFC3339),
			SlotAmount: remaining,
		})
	}

	return &out, nil
}

func (s *SlotServiceImpl) EditSlotCount(slotId uint, req model.ReduceSlotsRequest) error {
	slot := model.ReduceSlots{
		SlotID:     slotId,
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
	var petCategoryID uint
	if err := s.db.
		Table("pet").
		Select("species_id").
		Where("id = ?", req.PetID).
		Scan(&petCategoryID).
		Error; err != nil {
		return err
	}

	var pricingType string
	if err := s.db.
		Model(&model.PetDaycare{}).
		Select("pricing_type").
		Where("id = ?", req.DaycareID).
		Scan(&pricingType).Error; err != nil {
		return err
	}

	slot := model.Slots{
		PetCategoryID: petCategoryID,
		DaycareID:     req.DaycareID,
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
			PetID:            req.PetID,
			DaycareID:        req.DaycareID,
			StartDate:        req.StartDate,
			EndDate:          req.EndDate,
			UsePickupService: req.UsePickupService,
		}).
		Count(&bookedSlotsCount).
		Error; err != nil {
		return err
	}

	remainingSlots := slot.MaxNumber - int(bookedSlotsCount) - int(reducedSlotsCount)

	if remainingSlots <= 0 {
		return errors.New("Slots are full in between the chosen date")
	}

	if pricingType == "night" && int(req.EndDate.Sub(req.StartDate)/(24*time.Hour)) < 2 {
		return errors.New("Invalid booking: This pet daycare charges per night. A minimum of one night stay is required. Please adjust your booking dates.")
	}

	newBookSlot := model.BookedSlot{
		UserID:    userId,
		DaycareID: req.DaycareID,
		PetID:     req.PetID,
		StartDate: req.StartDate,
		EndDate:   req.EndDate,
	}

	newTransaction := model.Transaction{
		PetDaycareID: req.DaycareID,
		BookedSlot:   newBookSlot,
		UserID:       userId,
	}

	tx := s.db.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	if err := tx.Create(&newTransaction).Error; err != nil {
		return err
	}

	for d := req.StartDate; d.After(req.EndDate) == false; d = d.AddDate(0, 0, 1) {
		if err := tx.Create(&model.BookedSlotsDaily{
			DaycareID: req.DaycareID,
			Date:      d,
		}).Error; err != nil {
			return err
		}
	}

	return tx.Commit().Error
}
