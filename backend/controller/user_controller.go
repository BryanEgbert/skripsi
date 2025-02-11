package controller

import (
	"fmt"
	"math/rand"
	"net/http"
	"path/filepath"
	"strconv"
	"time"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
)

// UserController struct
type UserController struct {
	UserService service.UserService
}

// NewUserController initializes a new controller
func NewUserController(userService service.UserService) *UserController {
	return &UserController{UserService: userService}
}

// GetUser fetches a user by ID (keeps ID in URL param for admin access)
func (uc *UserController) GetUser(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	user, err := uc.UserService.GetUser(id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	c.JSON(http.StatusOK, user)
}

// CreateUser creates a user using ID from JWT
func (uc *UserController) CreateUser(c *gin.Context) {
	var req model.CreateUserRequest

	// Bind form-data
	if err := c.ShouldBind(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid form-data"})
		return
	}

	if req.RoleID == 3 {
		if req.VetSpecialtyID == nil || len(*req.VetSpecialtyID) == 0 {
			c.JSON(http.StatusBadRequest, gin.H{"error": "vet specialty is required for vet role"})
			return
		}
	}

	// Handle image upload
	if req.Image != nil {
		rand.New(rand.NewSource(time.Now().UnixNano())) // Seed to get different results each run
		randomNum := rand.Uint64()
		imagePath := fmt.Sprintf("image/%s", helper.GenerateFileName(uint(randomNum), filepath.Ext(req.Image.Filename)))

		if err := c.SaveUploadedFile(req.Image, imagePath); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save image", "details": err.Error()})
			return
		}

		req.ImageUrl = fmt.Sprintf("%s/%s", c.Request.Host, imagePath)
	}

	createdUser, err := uc.UserService.CreateUser(req)
	if err != nil {
		c.JSON(http.StatusConflict, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, createdUser)
}

// DeleteUser removes the logged-in user (ID from JWT)
func (uc *UserController) DeleteUser(c *gin.Context) {
	// Get user ID from JWT middleware
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User ID not found in token"})
		return
	}

	err := uc.UserService.DeleteUser(userID.(uint))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Failed to delete user"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// UpdateUserProfile updates the logged-in user's profile
func (uc *UserController) UpdateUserProfile(c *gin.Context) {
	// Get user ID from JWT
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User ID not found in token"})
		return
	}

	userID, ok := userIDRaw.(uint)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid user ID"})
		return
	}

	var req model.UpdateUserRequest
	if err := c.ShouldBind(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid form-data"})
		return
	}

	req.ID = userID

	// Handle image upload
	if req.Image != nil {
		imagePath := fmt.Sprintf("image/%s", helper.GenerateFileName(userID, filepath.Ext(req.Image.Filename)))

		if err := c.SaveUploadedFile(req.Image, imagePath); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save image", "details": err.Error()})
			return
		}

		req.ImageUrl = imagePath
	}

	updatedUser, err := uc.UserService.UpdateUserProfile(&req)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Failed to update user profile", "details": err.Error()})
		return
	}

	c.JSON(http.StatusOK, updatedUser)
}

// UpdateUserPassword updates the logged-in user's password
func (uc *UserController) UpdateUserPassword(c *gin.Context) {
	// Get user ID from JWT middleware
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User ID not found in token"})
		return
	}

	var req model.UpdatePasswordRequest

	if err := c.ShouldBindJSON(&req); err != nil || req.NewPassword == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	err := uc.UserService.UpdateUserPassword(userID.(uint), req.NewPassword)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Failed to update password", "details": err.Error()})
		return
	}

	c.Status(http.StatusNoContent)
}
