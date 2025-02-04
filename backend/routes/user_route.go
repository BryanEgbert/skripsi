package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/gin-gonic/gin"
)

func RegisterUserRoute(r *gin.Engine, userController *controller.UserController) *gin.Engine {
	r.POST("/users", userController.CreateUser)

	userRoutes := r.Group("/users")
	userRoutes.GET("/:id", userController.GetUser)
	userRoutes.DELETE("", userController.DeleteUser)
	userRoutes.PUT("", userController.UpdateUserProfile)
	userRoutes.PATCH("/password", userController.UpdateUserPassword)
	return r
}
