package model

type PetCategoryCount struct {
	PetCategory PetCategoryDTO `json:"petCategory"`
	Total       uint           `json:"total"`
}

type BookingRequest struct {
	ID             uint                  `json:"id"`
	User           UserDTO               `json:"user"`
	StartDate      string                `json:"startDate"`
	EndDate        string                `json:"endDate"`
	PickupRequired *bool                 `json:"pickupRequired"`
	PetCount       []PetCategoryCount    `json:"petCount"`
	AddressInfo    *BookedSlotAddressDTO `json:"addressInfo"`
	BookedPet      []PetDTO              `json:"bookedPet"`
}
