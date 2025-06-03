package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterAuthRoute(r *gin.Engine, authController *controller.AuthController) *gin.Engine {
	r.POST("/login", authController.Login)
	r.POST("/refresh", authController.RefreshToken)
	r.DELETE("/logout", middleware.JWTAuth(), authController.Logout)

	return r
}
