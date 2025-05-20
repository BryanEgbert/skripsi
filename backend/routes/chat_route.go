package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterChatRoute(r *gin.Engine, chatController *controller.ChatController) *gin.Engine {
	chatRoute := r.Group("/chat")
	chatRoute.PATCH("/read", middleware.JWTAuth(), chatController.UpdateRead)
	chatRoute.GET("/unread", middleware.JWTAuth(), chatController.GetUnreadMessage)
	chatRoute.GET("", middleware.JWTAuth(), chatController.Handle)
	chatRoute.GET("/user", middleware.JWTAuth(), chatController.GetUserChatList)

	r.GET("/chat-messages", middleware.JWTAuth(), chatController.GetMessages)

	return r
}
