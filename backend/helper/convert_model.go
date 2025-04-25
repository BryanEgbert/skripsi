package helper

import (
	"time"

	"github.com/BryanEgbert/skripsi/model"
)

// func calculateDistance(srcLat, srcLong, dstLat, dstLong float64) float64 {
// 	return 0.0
// }

func ConvertUserToDTO(user model.User) model.UserDTO {
	dto := model.UserDTO{
		ID:           user.ID,
		Name:         user.Name,
		Email:        user.Email,
		Role:         user.Role,
		CreatedAt:    user.CreatedAt.String(),
		ImageUrl:     "",
		VetSpecialty: []model.VetSpecialty{},
	}

	if user.ImageUrl != nil {
		dto.ImageUrl = *user.ImageUrl
	}

	if user.VetSpecialty != nil {
		dto.VetSpecialty = *user.VetSpecialty
	}

	return dto
}

func ConvertUserToUpdateDTO(user model.User) model.UpdateUserDTO {
	vetSpecialtyIds := []uint{}
	updateUserDTO := model.UpdateUserDTO{
		ID:     user.ID,
		Name:   user.Name,
		Email:  user.Email,
		RoleID: user.RoleID,
	}

	if user.VetSpecialty != nil {
		for _, specialty := range *user.VetSpecialty {
			vetSpecialtyIds = append(vetSpecialtyIds, specialty.ID)
		}
	}

	updateUserDTO.VetSpecialtyID = &vetSpecialtyIds

	return updateUserDTO
}

func ConvertPetDaycareToDTO(daycare model.PetDaycare) model.PetDaycareDTO {
	// Extract thumbnail URLs
	var thumbnailURLs []string
	for _, thumbnail := range daycare.Thumbnails {
		thumbnailURLs = append(thumbnailURLs, thumbnail.ImageUrl) // Assuming Thumbnail struct has a URL field
	}

	return model.PetDaycareDTO{
		ID:                daycare.ID,
		Name:              daycare.Name,
		Address:           daycare.Address,
		Locality:          daycare.Locality,
		Location:          daycare.Location,
		Description:       daycare.Description,
		BookedNum:         daycare.BookedNum,
		OpeningHour:       daycare.OpeningHour.Format("15:04"),
		ClosingHour:       daycare.ClosingHour.Format("15:04"),
		OwnerID:           daycare.OwnerID,
		HasPickupService:  daycare.HasPickupService,
		MustBeVaccinated:  daycare.MustBeVaccinated,
		GroomingAvailable: daycare.GroomingAvailable,
		FoodProvided:      daycare.FoodProvided,
		FoodBrand:         daycare.FoodBrand,
		CreatedAt:         daycare.CreatedAt,
		UpdatedAt:         daycare.UpdatedAt,
		DailyWalksID:      daycare.DailyWalksID,
		DailyPlaytimeID:   daycare.DailyPlaytimeID,
		ThumbnailURLs:     thumbnailURLs,
	}
}

func ConvertPetCategoryToDTO(petCategory model.PetCategory) model.PetCategoryDTO {
	return model.PetCategoryDTO{
		ID:           petCategory.ID,
		Name:         petCategory.Name,
		SizeCategory: petCategory.SizeCategory,
	}
}

func ConvertVaccineRecordsToDTO(vaccineRecords []model.VaccineRecord) []model.VaccineRecordDTO {
	out := []model.VaccineRecordDTO{}
	for _, record := range vaccineRecords {
		out = append(out, model.VaccineRecordDTO{
			ID:               record.ID,
			DateAdministered: record.DateAdministered,
			NextDueDate:      record.NextDueDate,
			ImageURL:         record.ImageURL,
		})
	}

	return out
}

func ConvertVaccineRecordToDTO(vaccineRecord model.VaccineRecord) model.VaccineRecordDTO {
	out := model.VaccineRecordDTO{
		ID:               vaccineRecord.ID,
		DateAdministered: vaccineRecord.DateAdministered,
		NextDueDate:      vaccineRecord.NextDueDate,
		ImageURL:         vaccineRecord.ImageURL,
	}

	return out
}

func ConvertPetsToDto(pets []model.Pet) []model.PetDTO {
	out := []model.PetDTO{}

	for _, val := range pets {
		pet := model.PetDTO{
			ID:          val.ID,
			Name:        val.Name,
			Status:      val.Status,
			Neutered:    val.Neutered,
			Owner:       ConvertUserToDTO(val.Owner),
			PetCategory: ConvertPetCategoryToDTO(val.PetCategory),
		}

		if val.ImageUrl != nil {
			pet.ImageUrl = *val.ImageUrl
		}

		out = append(out, pet)
	}

	return out
}

func ConvertReviewsToDto(reviews []model.Reviews) []model.ReviewsDTO {
	out := []model.ReviewsDTO{}

	for _, val := range reviews {
		review := model.ReviewsDTO{
			ID:          val.ID,
			Rating:      val.Rate,
			User:        ConvertUserToDTO(val.User),
			Description: val.Description,
			CreatedAt:   val.CreatedAt.Format(time.RFC3339),
			Title:       val.Name,
		}

		out = append(out, review)
	}

	return out
}

func ConvertTransactionsToTransactionDTO(transactions []model.Transaction) []model.TransactionDTO {
	var out []model.TransactionDTO

	for _, val := range transactions {
		out = append(out, model.TransactionDTO{
			ID: val.ID,
			Status: model.BookedSlotStatus{
				ID:   val.BookedSlot.Status.ID,
				Name: val.BookedSlot.Status.Name,
			},
			PetDaycare: ConvertPetDaycareToDetailResponse(val.PetDaycare, 0),
			StartDate:  val.BookedSlot.StartDate.Format(time.RFC3339),
			EndDate:    val.BookedSlot.EndDate.Format(time.RFC3339),
			BookedPet:  ConvertPetsToDto(val.BookedSlot.Pet),
			BookedSlot: ConvertBookedSlotToBookingRequest(val.BookedSlot),
		})

	}

	return out
}

func ConvertBookedSlotToBookingRequest(bookedSlot model.BookedSlot) model.BookingRequest {
	out := model.BookingRequest{
		ID:             bookedSlot.ID,
		User:           ConvertUserToDTO(bookedSlot.User),
		StartDate:      bookedSlot.StartDate.Format(time.RFC3339),
		EndDate:        bookedSlot.EndDate.Format(time.RFC3339),
		PickupRequired: &bookedSlot.UsePickupService,
		PetCount:       []model.PetCategoryCount{},
	}

	petCategory := make(map[uint]uint)

	for _, petC := range bookedSlot.Pet {
		petCategory[petC.PetCategory.ID] = petCategory[petC.PetCategory.ID] + 1
	}

	for key, count := range petCategory {
		var name string
		for _, petC := range bookedSlot.Pet {
			if petC.PetCategory.ID == key {
				name = petC.PetCategory.Name
			}
		}
		out.PetCount = append(out.PetCount, model.PetCategoryCount{PetCategory: model.PetCategoryDTO{ID: key, Name: name}, Total: count})
	}

	return out
}

func ConvertBookedSlotsToBookingRequests(bookedSlots []model.BookedSlot) []model.BookingRequest {
	var out []model.BookingRequest

	for _, val := range bookedSlots {
		bookingRequest := model.BookingRequest{
			ID:             val.ID,
			User:           ConvertUserToDTO(val.User),
			StartDate:      val.StartDate.Format(time.RFC3339),
			EndDate:        val.EndDate.Format(time.RFC3339),
			PickupRequired: &val.UsePickupService,
			PetCount:       []model.PetCategoryCount{},
		}

		petCategory := make(map[uint]uint)

		for _, petC := range val.Pet {
			petCategory[petC.PetCategory.ID] = petCategory[petC.PetCategory.ID] + 1
		}

		for key, count := range petCategory {
			var name string
			for _, petC := range val.Pet {
				if petC.PetCategory.ID == key {
					name = petC.PetCategory.Name
				}
			}
			bookingRequest.PetCount = append(bookingRequest.PetCount, model.PetCategoryCount{PetCategory: model.PetCategoryDTO{ID: key, Name: name}, Total: count})
		}

		out = append(out, bookingRequest)
	}

	return out
}

func ConvertPetDaycareToDetailResponse(daycare model.PetDaycare, distance float64) model.GetPetDaycareDetailResponse {
	// Extract thumbnail URLs
	thumbnailURLs := []string{}
	for _, thumbnail := range daycare.Thumbnails {
		thumbnailURLs = append(thumbnailURLs, thumbnail.ImageUrl)
	}

	// Calculate average rating and rating count
	var totalRating int
	var ratingCount int
	for _, review := range daycare.Reviews {
		totalRating += review.Rate
		ratingCount++
	}

	averageRating := 0.0
	if ratingCount > 0 {
		averageRating = float64(totalRating) / float64(ratingCount)
	}

	pricings := []model.PriceDetails{}
	for _, slot := range daycare.Slots {
		pricings = append(pricings, model.PriceDetails{
			PetCategory: model.PetCategoryDTO{
				ID:           slot.PetCategory.ID,
				Name:         slot.PetCategory.Name,
				SizeCategory: slot.PetCategory.SizeCategory,
				SlotAmount:   slot.MaxNumber,
			},
			Price:       slot.Price,
			PricingType: slot.PricingType,
		})
	}

	return model.GetPetDaycareDetailResponse{
		ID:                daycare.ID,
		Name:              daycare.Name,
		Address:           daycare.Address,
		Locality:          daycare.Locality,
		Location:          daycare.Location,
		Latitude:          daycare.Latitude,
		Longitude:         daycare.Longitude,
		OpeningHour:       daycare.OpeningHour.Format("15:04"),
		ClosingHour:       daycare.ClosingHour.Format("15:04"),
		Distance:          distance, // This should be calculated separately and passed as an argument
		Description:       daycare.Description,
		BookedNum:         daycare.BookedNum,
		AverageRating:     averageRating,
		RatingCount:       ratingCount,
		HasPickupService:  daycare.HasPickupService,
		MustBeVaccinated:  daycare.MustBeVaccinated,
		GroomingAvailable: daycare.GroomingAvailable,
		FoodProvided:      daycare.FoodProvided,
		FoodBrand:         daycare.FoodBrand,
		CreatedAt:         daycare.CreatedAt.Format(time.RFC3339), // Convert to string in ISO 8601 format
		Owner:             ConvertUserToDTO(daycare.Owner),        // Assuming you have a function to convert User to UserDTO
		DailyWalks:        daycare.DailyWalks,
		DailyPlaytime:     daycare.DailyPlaytime,
		ThumbnailURLs:     thumbnailURLs,
		Pricings:          pricings,
	}
}
