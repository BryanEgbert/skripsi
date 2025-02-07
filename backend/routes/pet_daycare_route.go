package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterPetDaycareRoutes(r *gin.Engine, petDaycareController *controller.PetDaycareController) *gin.Engine {
	pets := r.Group("/daycare")

	pets.GET("/:id", middleware.JWTAuth(), petDaycareController.GetPetDaycare)
	pets.GET("", middleware.JWTAuth(), petDaycareController.GetPetDaycares)
	pets.POST("", middleware.JWTAuth(), petDaycareController.CreatePetDaycare)
	pets.PUT("/:id", middleware.JWTAuth(), petDaycareController.UpdatePetDaycare)
	pets.DELETE("/:id", middleware.JWTAuth(), petDaycareController.DeletePetDaycare)

	return r
}
