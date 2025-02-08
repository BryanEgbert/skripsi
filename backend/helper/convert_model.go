package helper

import (
	"time"

	"github.com/BryanEgbert/skripsi/model"
)

// func calculateDistance(srcLat, srcLong, dstLat, dstLong float64) float64 {
// 	return 0.0
// }

func ConvertUserToDTO(user model.User) model.UserDTO {
	return model.UserDTO{
		ID:           user.ID,
		Name:         user.Name,
		Email:        user.Email,
		RoleID:       user.RoleID,
		CreatedAt:    user.CreatedAt,
		VetSpecialty: user.VetSpecialty,
	}
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
		Description:       daycare.Description,
		Price:             daycare.Price,
		PricingType:       daycare.PricingType,
		BookedNum:         daycare.BookedNum,
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

func ConvertPetDaycareToDetailResponse(daycare model.PetDaycare, distance float64) model.GetPetDaycareDetailResponse {
	// Extract thumbnail URLs
	var thumbnailURLs []string
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

	return model.GetPetDaycareDetailResponse{
		Name:              daycare.Name,
		Address:           daycare.Address,
		Distance:          distance, // This should be calculated separately and passed as an argument
		Price:             daycare.Price,
		PricingType:       daycare.PricingType,
		Description:       daycare.Description,
		BookedNum:         daycare.BookedNum,
		AverageRating:     averageRating,
		RatingCount:       ratingCount,
		DailyWalksID:      daycare.DailyWalksID,
		DailyPlaytimeID:   daycare.DailyPlaytimeID,
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
	}
}
