package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterImageRoute(r *gin.Engine, imageController *controller.ImageController) *gin.Engine {
	imageRoute := r.Group("/image")
	imageRoute.POST("", middleware.JWTAuth(), imageController.Upload)

	return r
}
