package controller

import (
	"net/http"

	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
)

// AuthController struct
type AuthController struct {
	authService service.AuthService
}

// NewAuthController initializes AuthController
func NewAuthController(authService service.AuthService) *AuthController {
	return &AuthController{authService: authService}
}

// LoginHandler handles user login requests
func (c *AuthController) Login(ctx *gin.Context) {
	var req model.LoginRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request body",
		})
		return
	}

	tokenResponse, err := c.authService.Login(req.Email, req.Password)
	if err != nil {
		ctx.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "Incorrect email or password",
			Error:   err.Error(),
		})
		return
	}

	ctx.JSON(http.StatusOK, tokenResponse)
}

// RefreshTokenHandler handles JWT refresh requests
func (c *AuthController) RefreshToken(ctx *gin.Context) {
	var req model.RefreshTokenRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request body",
			Error:   err.Error(),
		})
		return
	}

	tokenResponse, err := c.authService.RefreshToken(req.RefreshToken)
	if err != nil {
		ctx.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "Failed to refresh token",
			Error:   err.Error(),
		})
		return
	}

	ctx.JSON(http.StatusOK, tokenResponse)
}

func (c *AuthController) Logout(ctx *gin.Context) {
	userID, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "User ID not found in token",
		})
		return
	}

	if err := c.authService.Logout(userID.(uint)); err != nil {
		ctx.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "Failed to logout",
			Error:   err.Error(),
		})
		return
	}

	ctx.JSON(http.StatusNoContent, nil)

}
