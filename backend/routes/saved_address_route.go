package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterSavedAddressRoute(r *gin.Engine, savedAddressController *controller.SavedAddressController) *gin.Engine {
	routes := r.Group("/saved-address")
	routes.GET("", middleware.JWTAuth(), savedAddressController.GetSavedAddress)
	routes.GET("/:addressId", middleware.JWTAuth(), savedAddressController.GetSavedAddressById)
	routes.POST("", middleware.JWTAuth(), savedAddressController.AddSavedAddress)
	routes.DELETE("/:addressId", middleware.JWTAuth(), savedAddressController.DeleteSavedAddress)
	routes.PUT("/:addressId", middleware.JWTAuth(), savedAddressController.EditSavedAddress)

	return r
}
