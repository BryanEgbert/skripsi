package controller

import (
	"log"
	"net/http"
	"strconv"
	"sync"

	"firebase.google.com/go/v4/messaging"
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
	client      *messaging.Client
	chatService service.ChatService
	userService service.UserService
}

func NewChatController(chatService service.ChatService, userService service.UserService, client *messaging.Client) *ChatController {
	return &ChatController{chatService: chatService, client: client, userService: userService}
}

func (c *ChatController) GetUnreadMessage(ctx *gin.Context) {
	userIDRaw, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "Unauthorized",
		})
		return
	}

	userID, ok := userIDRaw.(uint)
	if !ok {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Invalid user ID",
		})
		return
	}

	data, err := c.chatService.GetUnreadMessages(uint(userID))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something went wrong",
			Error:   err.Error(),
		})
		return
	}

	ctx.JSON(http.StatusOK, data)
}

func (c *ChatController) UpdateRead(ctx *gin.Context) {
	userIDRaw, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "Unauthorized",
		})
		return
	}

	userID, ok := userIDRaw.(uint)
	if !ok {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Invalid user ID",
		})
		return
	}

	receiverIDQuery := ctx.Query("receiver-id")
	if receiverIDQuery == "" {
		ctx.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "invalid receiver ID",
		})
		return
	}

	receiverID, err := strconv.ParseUint(receiverIDQuery, 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid receiver ID",
			Error:   err.Error(),
		})
		return
	}

	if err := c.chatService.UpdateRead(userID, uint(receiverID)); err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something went wrong",
			Error:   err.Error(),
		})
		return
	}

	ctx.JSON(http.StatusNoContent, nil)
}

func (uc *ChatController) GetUserChatList(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "User ID not found in token",
		})
		return
	}

	userID, ok := userIDRaw.(uint)
	if !ok {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid user ID",
		})
		return
	}
	out, err := uc.chatService.GetUserChatList(userID)
	if err != nil {
		log.Printf("[ERROR] GetVetChatList err: %v", err)
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{Message: "Something's wrong", Error: err.Error()})

		return
	}

	c.JSON(http.StatusOK, out)
}

func (c *ChatController) GetMessages(ctx *gin.Context) {
	userIDRaw, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "Unauthorized",
		})
		return
	}

	userID, ok := userIDRaw.(uint)
	if !ok {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Invalid user ID",
		})
		return
	}

	receiverIDQuery := ctx.Query("receiver-id")
	if receiverIDQuery == "" {
		ctx.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "invalid receiver ID",
		})
		return
	}

	receiverID, err := strconv.ParseUint(receiverIDQuery, 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid receiver ID",
			Error:   err.Error(),
		})
		return
	}

	data, err := c.chatService.GetMessages(uint(userID), uint(receiverID))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something went wrong",
			Error:   err.Error(),
		})
		return
	}

	ctx.JSON(http.StatusOK, data)
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
		if msg.UpdateRead {
			if err := c.chatService.UpdateRead(senderID, msg.ReceiverID); err != nil {
				log.Printf("[ERROR] updateRead err: %v", err)
			}

			clientsMutex.RLock()
			receiverConn, ok := clients[msg.ReceiverID]
			clientsMutex.RUnlock()

			out, err := c.chatService.GetMessages(senderID, msg.ReceiverID)
			if err != nil {
				log.Printf("Get error: %v", err)
			}
			if ok {
				if err := receiverConn.WriteJSON(out); err != nil {
					log.Println("send error:", err)
				}

			}

			continue
		}

		newMessage := model.ChatMessage{
			SenderID:   senderID,
			ReceiverID: msg.ReceiverID,
			Message:    msg.Message,
			ImageURL:   msg.ImageURL,
			IsRead:     false,
		}

		_, err := c.chatService.InsertMessage(&newMessage)
		if err != nil {
			// chatMsg.Type = "error"
			// chatMsg.Message = err.Error()
			// conn.WriteJSON(chatMsg)
			log.Println("[ERROR] insert message err:", err)

			continue
		}

		clientsMutex.RLock()
		receiverConn, ok := clients[msg.ReceiverID]
		clientsMutex.RUnlock()

		out, err := c.chatService.GetMessages(senderID, msg.ReceiverID)
		if err != nil {
			log.Printf("Get error: %v", err)
		}
		if ok {
			// c.chatService.UpdateRead(senderID, chatMsg.ReceiverID)

			if err := receiverConn.WriteJSON(out); err != nil {
				log.Println("[ERROR] send error:", err)
			}

			token, err := c.userService.GetDeviceToken(msg.ReceiverID)
			if err != nil {
				log.Printf("[ERROR] get device token: %v", err)
				continue
			}

			if token == nil {
				continue
			}

			if _, err := c.client.Send(ctx, &messaging.Message{
				Data: map[string]string{
					"page": "chat",
				},
				Notification: &messaging.Notification{
					Title: "New Message",
					Body:  "New message incoming",
				},
				Token: *token,
			}); err != nil {
				log.Printf("[ERROR] sending message: %v\n", err)
			}

		}

		if err := conn.WriteJSON(out); err != nil {
			log.Println("[ERROR] send error:", err)
		}
	}
}
