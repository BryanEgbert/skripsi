package controller

import (
	"fmt"
	"net/http"
	"path/filepath"
	"strconv"
	"strings"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
)

type PetDaycareController struct {
	petDaycareService service.PetDaycareService
	slotService       service.SlotService
}

func NewPetDaycareController(petDaycareService service.PetDaycareService, slotService service.SlotService) *PetDaycareController {
	return &PetDaycareController{petDaycareService, slotService}
}

func (pdc *PetDaycareController) EditSlotCount(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	userID, ok := userIDRaw.(uint)
	if !ok {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	var req model.ReduceSlotsRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request data", "details": err.Error()})
		return
	}

	if err := pdc.slotService.EditSlotCount(uint(userID), req); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (pdc *PetDaycareController) GetPetDaycare(c *gin.Context) {
	petDaycareID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid pet daycare ID"})
		return
	}

	latitude, err := strconv.ParseFloat(c.Query("lat"), 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid latitude"})
		return
	}

	longitude, err := strconv.ParseFloat(c.Query("long"), 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid longitude"})
		return
	}

	output, err := pdc.petDaycareService.GetPetDaycare(uint(petDaycareID), latitude, longitude)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, output)
}

func (pdc *PetDaycareController) UpdatePetDaycare(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	userID, ok := userIDRaw.(uint)
	if !ok {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	petDaycareIDParam := c.Param("id")
	petDaycareID, err := strconv.ParseUint(petDaycareIDParam, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid pet daycare ID"})
		return
	}

	var request model.CreatePetDaycareRequest
	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request data", "details": err.Error()})
		return
	}

	if len(request.SpeciesID) != len(request.SizeCategoryID) || len(request.SpeciesID) != len(request.MaxNumber) || len(request.SizeCategoryID) != len(request.MaxNumber) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "speciesId, sizeCategoryId, and maxNumber must be the same length"})
		return
	}

	var thumbnailURLs []string
	for _, thumbnail := range request.Thumbnails {
		filename := fmt.Sprintf("image/%s", helper.GenerateFileName(userID, filepath.Ext(thumbnail.Filename)))
		thumbnailURLs = append(thumbnailURLs, fmt.Sprintf("%s/%s", c.Request.Host, filename))

		if err := c.SaveUploadedFile(thumbnail, filename); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save image", "details": err.Error()})
			return
		}
	}
	request.ThumbnailURLs = thumbnailURLs

	daycare, err := pdc.petDaycareService.UpdatePetDaycare(uint(petDaycareID), userID, request)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, daycare)
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
	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request data", "details": err.Error()})
		return
	}

	if len(request.SpeciesID) != len(request.SizeCategoryID) || len(request.SpeciesID) != len(request.MaxNumber) || len(request.SizeCategoryID) != len(request.MaxNumber) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "speciesId, sizeCategoryId, and maxNumber must be the same length"})
		return
	}

	var thumbnailURLs []string
	for _, thumbnail := range request.Thumbnails {
		filename := fmt.Sprintf("image/%s", helper.GenerateFileName(userID, filepath.Ext(thumbnail.Filename)))
		thumbnailURLs = append(thumbnailURLs, fmt.Sprintf("%s/%s", c.Request.Host, filename))

		if err := c.SaveUploadedFile(thumbnail, filename); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save image", "details": err.Error()})
			return
		}
	}
	request.ThumbnailURLs = thumbnailURLs

	daycare, err := pdc.petDaycareService.CreatePetDaycare(userID, request)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, daycare)
}

func (pdc *PetDaycareController) GetPetDaycares(c *gin.Context) {
	// Parse user GPS location
	userLat, err := strconv.ParseFloat(c.Query("lat"), 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid latitude"})
		return
	}

	userLng, err := strconv.ParseFloat(c.Query("lng"), 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid longitude"})
		return
	}

	// Parse filters
	var filters model.GetPetDaycaresRequest

	filters.Latitude = userLat
	filters.Longitude = userLng

	if minDist := c.Query("minDistance"); minDist != "" {
		value, _ := strconv.ParseFloat(minDist, 64)
		filters.MinDistance = &value
	}
	if maxDist := c.Query("maxDistance"); maxDist != "" {
		value, _ := strconv.ParseFloat(maxDist, 64)
		filters.MaxDistance = &value
	}
	if facilities := c.Query("facilities"); facilities != "" {
		filters.Facilities = strings.Split(facilities, ",")
	}
	if minPrice := c.Query("minPrice"); minPrice != "" {
		value, _ := strconv.ParseFloat(minPrice, 64)
		filters.MinPrice = &value
	}
	if maxPrice := c.Query("maxPrice"); maxPrice != "" {
		value, _ := strconv.ParseFloat(maxPrice, 64)
		filters.MaxPrice = &value
	}
	if pricingType := c.Query("pricingType"); pricingType != "" {
		filters.PricingType = &pricingType
	}

	// Call service
	daycares, err := pdc.petDaycareService.GetPetDaycares(filters)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, daycares)
}

func (pdc *PetDaycareController) DeletePetDaycare(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	userID, ok := userIDRaw.(uint)
	if !ok {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	petDaycareID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	if err := pdc.petDaycareService.DeletePetDaycare(uint(petDaycareID), uint(userID)); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (pdc *PetDaycareController) CreateSlot(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	userID, ok := userIDRaw.(uint)
	if !ok {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	var req model.BookSlotRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request data", "details": err.Error()})
		return
	}

	daycareId, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request data", "details": err.Error()})
		return
	}

	req.DaycareID = uint(daycareId)

	if err := pdc.slotService.BookSlots(userID, req); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
