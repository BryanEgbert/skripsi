package model

import "time"

type Transaction struct {
	ID        uint      `gorm:"primarykey"`
	CreatedAt time.Time `gorm:"default:current_timestamp"`
	// PetDaycareID uint       `gorm:"not null"`
	UserID       uint `gorm:"not null"`
	BookedSlotID uint `gorm:"not null"`
	// PetDaycare   PetDaycare `gorm:"foreignKey:PetDaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	BookedSlot BookedSlot `gorm:"foreignKey:BookedSlotID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	User       User       `gorm:"foreignKey:UserID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

type TransactionDTO struct {
	ID          uint                        `json:"id"`
	Status      BookedSlotStatus            `json:"status"`
	PetDaycare  GetPetDaycareDetailResponse `json:"petDaycare"`
	BookedSlot  BookingRequest              `json:"bookedSlot"`
	AddressInfo *SavedAddressDTO            `json:"addressInfo"`
	// BookedPet   []PetDTO                    `json:"bookedPet"`
	StartDate string `json:"startDate"`
	EndDate   string `json:"endDate"`
}
