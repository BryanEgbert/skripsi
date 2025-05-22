package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterPetDaycareRoutes(r *gin.Engine, petDaycareController *controller.PetDaycareController) *gin.Engine {
	daycare := r.Group("/daycare")

	daycare.GET("/booked-pet-owners", middleware.JWTAuth(), petDaycareController.GetBookedPetOwners)
	daycare.GET("/reduced-slot", middleware.JWTAuth(), petDaycareController.GetReducedSlots)
	daycare.GET("/pets", middleware.JWTAuth(), petDaycareController.GetBookedPets)
	daycare.GET("/booking-requests", middleware.JWTAuth(), petDaycareController.GetBookingRequests)

	daycare.GET("/:id/slot", middleware.JWTAuth(), petDaycareController.GetPetDaycareSlots)
	daycare.POST("/:id/slot", middleware.JWTAuth(), petDaycareController.BookSlot)

	daycare.GET("/:id/review", middleware.JWTAuth(), petDaycareController.GetReviews)
	daycare.POST("/:id/review", middleware.JWTAuth(), petDaycareController.CreateReview)
	daycare.DELETE("/:id/review", middleware.JWTAuth(), petDaycareController.DeleteReview)

	daycare.GET("/my", middleware.JWTAuth(), petDaycareController.GetMyPetdaycare)
	daycare.GET("/:id", middleware.JWTAuth(), petDaycareController.GetPetDaycare)
	// daycare.GET("", middleware.JWTAuth(), petDaycareController.GetPetDaycares)
	daycare.GET("", petDaycareController.GetPetDaycares)
	daycare.POST("", middleware.JWTAuth(), petDaycareController.CreatePetDaycare)
	daycare.PUT("/:id", middleware.JWTAuth(), petDaycareController.UpdatePetDaycare)
	daycare.DELETE("/:id", middleware.JWTAuth(), petDaycareController.DeletePetDaycare)

	return r
}
