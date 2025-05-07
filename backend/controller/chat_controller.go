package controller

import (
	"log"
	"net/http"
	"sync"
	"time"

	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

var clients = make(map[uint]*websocket.Conn)
var clientsMutex = &sync.RWMutex{}

type ChatController struct {
	chatService service.ChatService
}

func NewChatController(chatService service.ChatService) *ChatController {
	return &ChatController{chatService: chatService}
}

func (c *ChatController) Handle(ctx *gin.Context) {
	senderIDRaw, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "Unauthorized",
		})
		return
	}

	senderID, ok := senderIDRaw.(uint)
	if !ok {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Invalid user ID",
		})
		return
	}

	conn, err := upgrader.Upgrade(ctx.Writer, ctx.Request, nil)
	if err != nil {
		log.Println("WebSocket upgrade error:", err)
		return
	}
	defer conn.Close()

	clientsMutex.Lock()
	clients[uint(senderID)] = conn
	clientsMutex.Unlock()

	defer func() {
		clientsMutex.Lock()
		delete(clients, uint(senderID))
		clientsMutex.Unlock()
	}()

	for {
		var msg model.SendMessage

		if err := conn.ReadJSON(&msg); err != nil {
			log.Println("read error:", err)
			break
		}

		chatMsg := model.ChatMessageDTO{
			Type:       "message",
			SenderID:   senderID,
			ReceiverID: msg.ReceiverID,
			Message:    msg.Message,
			ImageURL:   msg.ImageURL,
			IsRead:     false,
			CreatedAt:  time.Now().Format(time.RFC3339),
		}

		newMessage := model.ChatMessage{
			SenderID:   senderID,
			ReceiverID: chatMsg.ReceiverID,
			Message:    chatMsg.Message,
			ImageURL:   chatMsg.ImageURL,
			IsRead:     chatMsg.IsRead,
		}

		chatId, err := c.chatService.InsertMessage(&newMessage)
		if err != nil {
			chatMsg.Type = "error"
			chatMsg.Message = err.Error()
			conn.WriteJSON(chatMsg)

			continue
		}
		chatMsg.ID = chatId

		clientsMutex.RLock()
		receiverConn, ok := clients[msg.ReceiverID]
		clientsMutex.RUnlock()

		if err := conn.WriteJSON(chatMsg); err != nil {
			log.Println("send error:", err)
		}

		if ok {

			if err := receiverConn.WriteJSON(chatMsg); err != nil {
				log.Println("send error:", err)
			}
		}
	}
}
