package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterPetDaycareRoutes(r *gin.Engine, petDaycareController *controller.PetDaycareController) *gin.Engine {
	daycare := r.Group("/daycare")

	daycare.GET("/:id", middleware.JWTAuth(), petDaycareController.GetPetDaycare)
	daycare.GET("", middleware.JWTAuth(), petDaycareController.GetPetDaycares)
	daycare.GET("/:id/slot", middleware.JWTAuth(), petDaycareController.GetPetDaycareSlots)
	daycare.POST("/:id/slot", middleware.JWTAuth(), petDaycareController.CreateSlot)
	daycare.POST("", middleware.JWTAuth(), petDaycareController.CreatePetDaycare)
	daycare.PUT("/:id", middleware.JWTAuth(), petDaycareController.UpdatePetDaycare)
	daycare.PATCH("", middleware.JWTAuth(), petDaycareController.EditSlotCount)
	daycare.DELETE("/:id", middleware.JWTAuth(), petDaycareController.DeletePetDaycare)

	return r
}
