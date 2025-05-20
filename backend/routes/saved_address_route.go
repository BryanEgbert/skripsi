package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterSavedAddressRoute(r *gin.Engine, savedAddressController *controller.SavedAddressController) *gin.Engine {
	routes := r.Group("/saved-address")
	routes.GET("/saved-address", middleware.JWTAuth(), savedAddressController.GetSavedAddress)
	routes.POST("/saved-address", middleware.JWTAuth(), savedAddressController.AddSavedAddress)
	routes.DELETE("/saved-address/:addressId", middleware.JWTAuth(), savedAddressController.DeleteSavedAddress)
	routes.PUT("/saved-address/:addressId", middleware.JWTAuth(), savedAddressController.EditSavedAddress)

	return r
}
