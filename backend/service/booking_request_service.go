package service

import (
	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type BookingRequestService interface {
	GetBookingRequests(userID uint, page int, pageSize int) (model.ListData[model.BookingRequest], error)
}

type BookingRequestServiceImpl struct {
	db *gorm.DB
}

func NewBookingRequestService(db *gorm.DB) *BookingRequestServiceImpl {
	return &BookingRequestServiceImpl{db: db}
}

func (s *BookingRequestServiceImpl) GetBookingRequests(userID uint, page int, pageSize int) (model.ListData[model.BookingRequest], error) {
	var bookedSlots []model.BookedSlot

	if err := s.db.Model(&model.BookedSlot{Daycare: model.PetDaycare{OwnerID: userID}}).
		Preload("Pet").
		Preload("Pet.PetCategory").
		Preload("Address").
		Joins("Status").
		Joins("Daycare", s.db.Omit("Distance")).
		Joins("User").
		Where("status_id = 1").
		Offset((page - 1) * pageSize).
		Limit(pageSize).
		Find(&bookedSlots).Error; err != nil {
		return model.ListData[model.BookingRequest]{}, err
	}

	out := helper.ConvertBookedSlotsToBookingRequests(bookedSlots)

	return model.ListData[model.BookingRequest]{Data: out}, nil

}
