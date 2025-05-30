package service

import (
	"errors"
	"log"
	"time"

	apputils "github.com/BryanEgbert/skripsi/app_utils"
	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type SlotService interface {
	GetSlots(petDaycareId uint, req model.GetSlotRequest) (*[]model.SlotsResponse, error)
	BookSlots(userId uint, req model.BookSlotRequest) error
	EditSlotCount(userId uint, slotId uint, req model.ReduceSlotsRequest) error
	GetReducedSlot(userId uint, page int, pageSize int) ([]model.ReduceSlotsDTO, error)
	DeleteReducedSlot(slotId uint) error
	AcceptBookedSlot(slotId uint) error
	RejectBookedSlot(slotId uint) error
	CancelBookedSlot(slotId uint) error
	GetBookingRequests(userID uint, page int, pageSize int) (model.ListData[model.BookingRequest], error)
	GetBookedSlot(id uint, userId uint) (*model.BookedSlotDTO, error)
	GetBookedSlots(userId uint, page int, pageSize int) (*[]model.BookedSlotDTO, error)
}

type SlotServiceImpl struct {
	db *gorm.DB
}

func NewSlotService(db *gorm.DB) *SlotServiceImpl {
	return &SlotServiceImpl{db: db}
}

func (s *SlotServiceImpl) GetBookedSlot(id uint, userId uint) (*model.BookedSlotDTO, error) {
	var transaction model.BookedSlot

	if err := s.db.
		Model(&model.BookedSlot{}).
		Preload("User").
		Preload("Status").
		Preload("Pet").
		Preload("Pet.PetCategory").
		Preload("Pet.PetCategory.SizeCategory").
		Preload("Address").
		Preload("Daycare").
		Preload("Daycare.Slots").
		Preload("Daycare.Slots.PricingType").
		Preload("Daycare.Slots.PetCategory").
		Preload("Daycare.Slots.PetCategory.SizeCategory").
		Where("id = ? AND user_id = ?", id, userId).
		Find(&transaction).Error; err != nil {
		return nil, err
	}

	out := helper.ConvertTransactionToTransactionDTO(transaction)

	return &out, nil
}

func (s *SlotServiceImpl) GetBookedSlots(userId uint, page int, pageSize int) (*[]model.BookedSlotDTO, error) {
	var transactions []model.BookedSlot

	if err := s.db.
		Model(&model.BookedSlot{}).
		Preload("User").
		Preload("Status").
		Preload("Pet").
		Preload("Pet.PetCategory").
		Preload("Pet.PetCategory.SizeCategory").
		Preload("Address").
		Preload("Daycare").
		Preload("Daycare.Slots").
		Preload("Daycare.Slots.PricingType").
		Preload("Daycare.Slots.PetCategory").
		Preload("Daycare.Slots.PetCategory.SizeCategory").
		Where("user_id = ?", userId).
		Offset((page - 1) * pageSize).
		Limit(pageSize).
		Find(&transactions).Error; err != nil {
		return nil, err
	}

	out := helper.ConvertTransactionsToTransactionDTO(transactions)

	return &out, nil
}

func (s *SlotServiceImpl) GetBookingRequests(userID uint, page int, pageSize int) (model.ListData[model.BookingRequest], error) {
	var bookedSlots []model.BookedSlot

	if err := s.db.
		Model(&model.BookedSlot{}).
		Preload("Pet").
		Preload("Pet.PetCategory").
		Preload("Address").
		Joins("Status").
		Joins("Daycare", s.db.Omit("Distance")).
		Joins("User").
		Where("status_id = ? AND \"Daycare\".owner_id = ?", 1, userID).
		Offset((page - 1) * pageSize).
		Limit(pageSize).
		Find(&bookedSlots).Error; err != nil {
		return model.ListData[model.BookingRequest]{}, err
	}

	out := helper.ConvertBookedSlotsToBookingRequests(bookedSlots)

	return model.ListData[model.BookingRequest]{Data: out}, nil

}

func (s *SlotServiceImpl) DeleteReducedSlot(slotId uint) error {
	if err := s.db.Delete(&model.ReduceSlots{}, slotId).Error; err != nil {
		return err
	}

	return nil
}

func (s *SlotServiceImpl) GetReducedSlot(userId uint, page int, pageSize int) ([]model.ReduceSlotsDTO, error) {
	daycare := model.PetDaycare{
		OwnerID: userId,
	}

	if err := s.db.
		Preload("Owner").
		Preload("Owner.Role").
		Preload("DailyWalks").
		Preload("DailyPlaytime").
		Preload("Thumbnails").
		Preload("Reviews").
		Preload("Slots").
		Preload("Slots.PricingType").
		Preload("Slots.PetCategory").
		Preload("Slots.PetCategory.SizeCategory").
		Where("owner_id = ?", userId).
		First(&daycare).Error; err != nil {
		return nil, err
	}

	slotID := []uint{}
	for _, val := range daycare.Slots {
		slotID = append(slotID, val.ID)
	}

	out := []model.ReduceSlots{}

	if err := s.db.
		Model(&model.ReduceSlots{}).
		Where("slot_id IN ?", slotID).
		Offset(pageSize * (page - 1)).
		Limit(pageSize).
		Find(&out).Error; err != nil {
		return nil, err
	}

	dto := helper.ConvertReducedSlotsToDTO(out)

	return dto, nil
}

func (s *SlotServiceImpl) AcceptBookedSlot(slotId uint) error {
	// bookedSlot := model.BookedSlot{Model: gorm.Model{ID: slotId}}tx := s.db.Begin()
	tx := s.db.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	if err := tx.
		Model(&model.BookedSlot{}).
		Where("id = ?", slotId).
		Update("status_id", 2).Error; err != nil {
		tx.Rollback()
		return err
	}

	var bookedSlot model.BookedSlot
	if err := tx.First(&bookedSlot, slotId).Error; err != nil {
		tx.Rollback()
		return err
	}

	if err := tx.Table("pet_daycares").
		Where("pet_daycares.id = ?", bookedSlot.DaycareID).
		UpdateColumn("booked_num", gorm.Expr("booked_num + ?", 1)).Error; err != nil {
		tx.Rollback()
		return err
	}

	if err := tx.Commit().Error; err != nil {
		return err
	}

	return nil
}
func (s *SlotServiceImpl) RejectBookedSlot(slotId uint) error {
	if err := s.db.
		Model(&model.BookedSlot{}).
		Where("id = ?", slotId).
		Update("status_id", 3).Error; err != nil {
		return err
	}

	return nil
}
func (s *SlotServiceImpl) CancelBookedSlot(slotId uint) error {
	if err := s.db.
		Model(&model.BookedSlot{}).
		Where("id = ?", slotId).
		Update("status_id", 5).Error; err != nil {
		return err
	}

	return nil
}

func (s *SlotServiceImpl) GetSlots(petDaycareId uint, req model.GetSlotRequest) (*[]model.SlotsResponse, error) {
	firstDay := time.Now()

	lastDay := firstDay.AddDate(1, 0, 0)

	var slots []model.Slots
	if err := s.db.
		Where("daycare_id = ? AND pet_category_id IN ?", petDaycareId, req.PetCategoryID).
		Find(&slots).Error; err != nil {
		return nil, err
	}

	slotID := []uint{}
	for _, val := range slots {
		slotID = append(slotID, val.ID)
	}
	log.Printf("slot ID: %v", slotID)

	var reduceSlots []model.ReduceSlots
	if err := s.db.
		Where("slot_id IN ?", slotID).
		Find(&reduceSlots).Error; err != nil {
		return nil, err
	}

	var bookedSlots []model.BookedSlotsDailyDTO
	rows, err := s.db.
		Model(&model.BookedSlotsDaily{}).
		Select("date, SUM(slot_count) AS slot_count").
		Where("slot_id IN ? AND date BETWEEN ? AND ?", slotID, firstDay.AddDate(0, 0, -1), lastDay).
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
		var remainingSlot []int
		for _, slot := range slots {
			dateStr := day.Format("2006-01-02")

			maxSlots := int(slot.MaxNumber)          // Default slots
			reduced := reduceSlotsMap[dateStr]       // Reduced slots
			booked := bookedSlotsMap[dateStr]        // Booked slots
			remaining := maxSlots - reduced - booked // Remaining slots
			remainingSlot = append(remainingSlot, remaining)
		}
		if len(remainingSlot) == 1 {
			out = append(out, model.SlotsResponse{
				Date:       day.Format(time.RFC3339),
				SlotAmount: remainingSlot[0],
			})
		} else {
			minSlot := -1
			for _, val := range remainingSlot {
				if minSlot == -1 {
					minSlot = val
				} else if val < minSlot {
					minSlot = val
				}
			}

			out = append(out, model.SlotsResponse{
				Date:       day.Format(time.RFC3339),
				SlotAmount: minSlot,
			})
		}
	}

	return &out, nil
}

func (s *SlotServiceImpl) EditSlotCount(userId uint, slotId uint, req model.ReduceSlotsRequest) error {
	daycare := model.PetDaycare{
		OwnerID: userId,
	}

	if err := s.db.
		Preload("Owner").
		Preload("Owner.Role").
		Where("owner_id = ?", userId).
		First(&daycare).Error; err != nil {
		return err
	}

	slot := model.ReduceSlots{
		SlotID:       slotId,
		TargetDate:   req.TargetDate,
		ReducedCount: req.ReducedCount,
	}

	if err := s.db.
		Model(&model.ReduceSlots{SlotID: slotId}).
		UpdateColumn("reduced_count", req.ReducedCount).
		Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			s.db.Create(&slot) // create new record from newUser
		}
		return err
	}

	if err := s.db.Save(slot).Error; err != nil {
		return err
	}

	return nil
}

func (s *SlotServiceImpl) BookSlots(userId uint, req model.BookSlotRequest) error {
	var count int64
	if err := s.db.
		Joins("JOIN pet_booked_slots pbs ON pbs.booked_slot_id = booked_slots.id").
		Where("pbs.pet_id IN ? AND booked_slots.status_id IN ?", req.PetID, []uint{1, 2, 4}).
		Count(&count).
		Error; err != nil {
		return err
	}

	if count > 0 {
		return apputils.ErrPetAlreadyBooked
	}

	var petCategoryID []uint
	if err := s.db.
		Table("pets").
		Select("DISTINCT(pet_category_id) AS petCategoryId").
		Where("id IN ?", req.PetID).
		Scan(&petCategoryID).
		Error; err != nil {
		return err
	}

	var pricingType string
	if err := s.db.
		Model(&model.Slots{}).
		Select("pricing_types.name").
		Joins("JOIN pricing_types ON pricing_types.id = pricing_type_id").
		Where("daycare_id = ? AND pet_category_id = ?", req.DaycareID, petCategoryID).
		Scan(&pricingType).Error; err != nil {
		return err
	}

	var slot []model.Slots
	if err := s.db.
		Where("daycare_id = ? AND pet_category_id IN ?", req.DaycareID, petCategoryID).
		Find(&slot).Error; err != nil {
		return err
	}

	log.Printf("slot length: %d", len(slot))

	slotID := []uint{}
	for _, val := range slot {
		slotID = append(slotID, val.ID)
	}

	// var reducedSlotsCount []int64

	// if err := s.db.
	// 	Model(&model.ReduceSlots{}).
	// 	Select("COALESCE(SUM(reduced_count),0) AS total").
	// 	Where("slot_id IN ? AND target_date BETWEEN ? AND ?", slotID, req.StartDate, req.EndDate).
	// 	Scan(&reducedSlotsCount).
	// 	Error; err != nil {
	// 	return err
	// }

	// TODO: loop date instead of add counts
	for _, val := range slot {
		var bookedSlotsCount int64
		if err := s.db.
			Model(&model.BookedSlot{
				// DaycareID: req.DaycareID,
				SlotID:    val.ID,
				StartDate: req.StartDate,
				EndDate:   req.EndDate,
			}).
			Count(&bookedSlotsCount).
			Error; err != nil {
			return err
		}
		// remainingSlots := val.MaxNumber - int(bookedSlotsCount) - int(reducedSlotsCount[i])
		remainingSlots := val.MaxNumber - int(bookedSlotsCount)

		if remainingSlots <= 0 {
			return apputils.ErrSlotFull
		}
	}

	if pricingType == "night" && int(req.EndDate.Sub(req.StartDate)/(24*time.Hour)) < 2 {
		return apputils.ErrOnlyOneSlotDate
	}

	// Insert Data
	tx := s.db.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	for _, val := range slot {
		// var newBookSlot model.BookedSlot
		// if req.AddressID == 0 {
		// 	var address model.SavedAddress
		// 	var addressID *uint
		// 	if req.Location != nil && req.Address != nil && req.Latitude != nil && req.Longitude != nil {
		// 		address = model.SavedAddress{
		// 			Name:      *req.Location,
		// 			Address:   *req.Address,
		// 			Latitude:  *req.Latitude,
		// 			Longitude: *req.Latitude,
		// 			Notes:     req.Notes,
		// 		}

		// 		if err := tx.Create(&address).Error; err != nil {
		// 			return err
		// 		}

		// 		addressID = &address.ID
		// 	}

		// 	newBookSlot = model.BookedSlot{
		// 		UserID: userId,
		// 		SlotID: val.ID,
		// 		// DaycareID: req.DaycareID,
		// 		StartDate: req.StartDate,
		// 		EndDate:   req.EndDate,
		// 		AddressID: addressID,
		// 	}
		// }
		newBookSlot := model.BookedSlot{
			UserID:    userId,
			SlotID:    val.ID,
			DaycareID: req.DaycareID,
			StartDate: req.StartDate,
			EndDate:   req.EndDate,
			AddressID: &req.AddressID,
		}

		if req.AddressID != 0 {
			newBookSlot.AddressID = &req.AddressID
		}

		if err := tx.Create(&newBookSlot).Error; err != nil {
			tx.Rollback()
			return err
		}

		// newTransaction := model.Transaction{
		// 	// PetDaycareID: req.DaycareID,
		// 	BookedSlot: newBookSlot,
		// 	UserID:     userId,
		// }

		// if err := tx.Create(&newTransaction).Error; err != nil {
		// 	tx.Rollback()
		// 	return err
		// }

		for _, petID := range req.PetID {
			if err := tx.Model(&newBookSlot).
				Association("Pet").
				Append(&model.Pet{Model: gorm.Model{ID: petID}}); err != nil {
				tx.Rollback()
				return err
			}

			for d := req.StartDate; !d.After(req.EndDate); d = d.AddDate(0, 0, 1) {
				if err := tx.Create(&model.BookedSlotsDaily{
					SlotID: val.ID,
					// DaycareID: req.DaycareID,
					Date: d,
				}).Error; err != nil {
					tx.Rollback()
					return err
				}
			}
		}

	}

	return tx.Commit().Error
}
