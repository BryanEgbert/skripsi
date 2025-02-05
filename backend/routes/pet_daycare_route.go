package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterPetDaycareRoutes(r *gin.Engine, petDaycareController *controller.PetDaycareController) *gin.Engine {
	pets := r.Group("/daycare")

	// pets.GET("/:id", middleware.JWTAuth(), petController.GetPet)
	// pets.GET("", middleware.JWTAuth(), petController.GetPets)
	pets.POST("", middleware.JWTAuth(), petDaycareController.CreatePetDaycare)
	// pets.PUT("/:id", middleware.JWTAuth(), petController.UpdatePet)
	// pets.DELETE("/:id", middleware.JWTAuth(), petController.DeletePet)

	return r
}
