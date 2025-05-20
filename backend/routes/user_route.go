package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterUserRoute(r *gin.Engine, userController *controller.UserController) *gin.Engine {
	r.POST("/users", userController.CreateUser)
	r.POST("/pet-owner", userController.CreatePetOwner)
	r.POST("/pet-daycare-provider", userController.CreatePetDaycareProvider)

	userRoutes := r.Group("/users")
	userRoutes.GET("/vets", middleware.JWTAuth(), userController.GetVets)
	userRoutes.GET("/:id", middleware.JWTAuth(), userController.GetUser)

	userRoutes.DELETE("", middleware.JWTAuth(), userController.DeleteUser)
	userRoutes.PUT("", middleware.JWTAuth(), userController.UpdateUserProfile)
	userRoutes.PATCH("/password", middleware.JWTAuth(), userController.UpdateUserPassword)

	return r
}
