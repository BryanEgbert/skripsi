package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterPetRoutes(r *gin.Engine, petController *controller.PetController, vc *controller.VaccineRecordController) *gin.Engine {
	pets := r.Group("/pets")

	pets.GET("/:id", middleware.JWTAuth(), petController.GetPet)
	pets.GET("/:id/vaccination-record", middleware.JWTAuth(), vc.GetVaccineRecords)
	pets.PUT("/:id", middleware.JWTAuth(), petController.UpdatePet)
	pets.DELETE("/:id", middleware.JWTAuth(), petController.DeletePet)
	pets.GET("", middleware.JWTAuth(), petController.GetPets)
	pets.POST("", middleware.JWTAuth(), petController.CreatePet)
	r.POST("/:id/vaccination-record", middleware.JWTAuth(), vc.CreateVaccineRecords)

	return r
}
