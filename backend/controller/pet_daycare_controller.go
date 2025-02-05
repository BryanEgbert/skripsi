package controller

import (
	"net/http"

	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
)

type PetDaycareController struct {
	petDaycareService service.PetDaycareService
}

func NewPetDaycareController(petDaycareService service.PetDaycareService) *PetDaycareController {
	return &PetDaycareController{petDaycareService}
}

// CreatePetDaycare handles the creation of a new pet daycare
func (pdc *PetDaycareController) CreatePetDaycare(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	userID, ok := userIDRaw.(uint)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid user ID"})
		return
	}

	var request model.CreatePetDaycareRequest

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request data"})
		return
	}

	daycare, err := pdc.petDaycareService.CreatePetDaycare(userID, request)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, daycare)
}
