package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterChatRoute(r *gin.Engine, chatController *controller.ChatController) *gin.Engine {
	r.GET("/chat", middleware.JWTAuth(), chatController.Handle)

	return r
}
