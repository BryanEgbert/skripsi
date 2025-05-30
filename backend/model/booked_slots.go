package model

import (
	"time"

	"gorm.io/gorm"
)

type BookedSlot struct {
	gorm.Model
	UserID    uint      `gorm:"not null"`
	SlotID    uint      `gorm:"not null"`
	DaycareID uint      `gorm:"not null"`
	StartDate time.Time `gorm:"not null"`
	EndDate   time.Time `gorm:"not null"`
	StatusID  *uint     `gorm:"default:1"`
	AddressID *uint     `gorm:"default:null"`

	User    User             `gorm:"foreignKey:UserID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	Pet     []Pet            `gorm:"many2many:pet_booked_slots;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	Daycare PetDaycare       `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	Status  BookedSlotStatus `gorm:"foreignKey:StatusID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	Address SavedAddress     `gorm:"foreignKey:AddressID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

type BookSlotRequest struct {
	DaycareID uint
	PetID     []uint    `json:"petId" binding:"required"`
	StartDate time.Time `json:"startDate" binding:"required"`
	EndDate   time.Time `json:"endDate" binding:"required"`
	AddressID uint      `json:"addressId"`
}

type BookedSlotDTO struct {
	ID          uint                        `json:"id"`
	Status      BookedSlotStatus            `json:"status"`
	PetDaycare  GetPetDaycareDetailResponse `json:"petDaycare"`
	BookedSlot  BookingRequest              `json:"bookedSlot"`
	AddressInfo *SavedAddressDTO            `json:"addressInfo"`
	StartDate   string                      `json:"startDate"`
	EndDate     string                      `json:"endDate"`
	IsReviewed  bool                        `json:"isReviewed"`
	// BookedPet   []PetDTO                    `json:"bookedPet"`
}
