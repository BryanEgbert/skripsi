package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/gin-gonic/gin"
)

func RegisterCategoryRoutes(r *gin.Engine, categoryController *controller.CategoryController) *gin.Engine {
	r.GET("/vet-specialties", categoryController.GetVetSpecialties)
	r.GET("/pet-categories", categoryController.GetPetCategories)
	r.GET("size-categories", categoryController.GetSizeCategories)
	r.GET("/daily-walks", categoryController.GetDailyWalks)
	r.GET("/daily-playtimes", categoryController.GetDailyPlaytime)
	r.GET("/pricing-types", categoryController.GetPricingType)

	return r
}
