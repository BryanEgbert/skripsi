package controller

import (
	"errors"
	"fmt"
	"net/http"
	"path/filepath"
	"strconv"
	"strings"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type PetDaycareController struct {
	petDaycareService service.PetDaycareService
	slotService       service.SlotService
	petService        service.PetService
	reviewService     service.ReviewService
}

func NewPetDaycareController(petDaycareService service.PetDaycareService, petService service.PetService, slotService service.SlotService, reviewService service.ReviewService) *PetDaycareController {
	return &PetDaycareController{petDaycareService, slotService, petService, reviewService}
}

func (pdc *PetDaycareController) GetReviews(c *gin.Context) {
	petDaycareID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid pet daycare ID",
			Error:   err.Error(),
		})
		return
	}

	// Get optional pagination parameters
	lastIDQuery := c.Query("last-id")
	var lastID uint64 = 0
	if lastIDQuery != "" {
		lastID, err = strconv.ParseUint(lastIDQuery, 10, 64)
		if err != nil {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{
				Message: "Invalid last ID",
				Error:   err.Error(),
			})
			return
		}
	}

	sizeQuery := c.Query("size")
	var pageSize int = 10

	if sizeQuery != "" {
		pageSize, err = strconv.Atoi(sizeQuery)
		if err != nil {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{
				Message: "Invalid page size",
				Error:   err.Error(),
			})
			return
		}
	}

	// Fetch reviews using the service
	reviews, err := pdc.reviewService.GetReviews(uint(petDaycareID), uint(lastID), pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to retrieve reviews",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": reviews})
}

func (pdc *PetDaycareController) CreateReview(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Unauthorized",
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

	petDaycareID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid pet daycare ID",
			Error:   err.Error(),
		})
		return
	}

	var req model.CreateReviewRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request body",
			Error:   err.Error(),
		})
		return
	}

	err = pdc.reviewService.CreateReview(uint(petDaycareID), uint(userID), req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to create review",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, nil)
}

func (pdc *PetDaycareController) DeleteReview(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "Unauthorized",
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

	petDaycareID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid pet daycare ID",
			Error:   err.Error(),
		})
		return
	}

	err = pdc.reviewService.DeleteReview(uint(petDaycareID), uint(userID))
	if err != nil {
		c.JSON(http.StatusNotFound, model.ErrorResponse{
			Message: "Review not found",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (pdc *PetDaycareController) EditSlotCount(c *gin.Context) {
	slotID, err := strconv.ParseUint(c.Param("slotId"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid slot ID",
		})
		return
	}

	var req model.ReduceSlotsRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request data",
			Error:   err.Error(),
		})
		return
	}

	if err := pdc.slotService.EditSlotCount(uint(slotID), req); err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Cannot edit slot count",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (pdc *PetDaycareController) GetPetDaycareSlots(c *gin.Context) {
	speciesId, err := strconv.ParseInt(c.Query("species"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid species",
			Error:   err.Error(),
		})
		return
	}

	sizeCategoryId, err := strconv.ParseInt(c.Query("size"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid size category",
			Error:   err.Error(),
		})
		return
	}

	year, err := strconv.ParseInt(c.Query("year"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid year",
			Error:   err.Error(),
		})
		return
	}

	month, err := strconv.ParseInt(c.Query("month"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid month",
			Error:   err.Error(),
		})
		return
	}

	petDaycareIDParam := c.Param("id")
	petDaycareID, err := strconv.ParseUint(petDaycareIDParam, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid pet daycare ID",
			Error:   err.Error(),
		})
		return
	}

	output, err := pdc.slotService.GetSlots(uint(petDaycareID), model.GetSlotRequest{
		SpeciesID:      uint(speciesId),
		SizeCategoryID: uint(sizeCategoryId),
		Year:           int(year),
		Month:          int(month),
	})
	if err != nil {
		c.JSON(http.StatusNotFound, model.ErrorResponse{
			Message: "Failed to get slots",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, model.ListData[model.SlotsResponse]{Data: *output})
}

func (pdc *PetDaycareController) GetPetDaycare(c *gin.Context) {
	petDaycareID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid pet daycare ID",
			Error:   err.Error(),
		})
		return
	}

	latitude, err := strconv.ParseFloat(c.Query("lat"), 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid latitude",
			Error:   err.Error(),
		})
		return
	}

	longitude, err := strconv.ParseFloat(c.Query("long"), 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid longitude",
			Error:   err.Error(),
		})
		return
	}

	output, err := pdc.petDaycareService.GetPetDaycare(uint(petDaycareID), latitude, longitude)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, model.ErrorResponse{
				Message: "Pet daycare does not exists",
				Error:   err.Error(),
			})
			return
		}

		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to fetch pet daycare",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, output)
}

func (pdc *PetDaycareController) UpdatePetDaycare(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "Unauthorized",
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

	petDaycareIDParam := c.Param("id")
	petDaycareID, err := strconv.ParseUint(petDaycareIDParam, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid pet daycare ID",
		})
		return
	}

	var request model.CreatePetDaycareRequest
	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request data",
			Error:   err.Error(),
		})
		return
	}

	if len(request.SpeciesID) != len(request.SizeCategoryID) || len(request.SpeciesID) != len(request.MaxNumber) || len(request.SizeCategoryID) != len(request.MaxNumber) {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "speciesId, sizeCategoryId, and maxNumber must be the same length",
		})
		return
	}

	var thumbnailURLs []string
	for _, thumbnail := range request.Thumbnails {
		filename := fmt.Sprintf("image/%s", helper.GenerateFileName(userID, filepath.Ext(thumbnail.Filename)))
		thumbnailURLs = append(thumbnailURLs, fmt.Sprintf("%s/%s", c.Request.Host, filename))

		if err := c.SaveUploadedFile(thumbnail, filename); err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Failed to save image",
				Error:   err.Error(),
			})
			return
		}
	}
	request.ThumbnailURLs = thumbnailURLs

	daycare, err := pdc.petDaycareService.UpdatePetDaycare(uint(petDaycareID), userID, request)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to update pet daycare",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, daycare)
}

// CreatePetDaycare handles the creation of a new pet daycare
func (pdc *PetDaycareController) CreatePetDaycare(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "Unauthorized",
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

	var request model.CreatePetDaycareRequest
	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request data",
			Error:   err.Error(),
		})
		return
	}

	if len(request.SpeciesID) != len(request.SizeCategoryID) || len(request.SpeciesID) != len(request.MaxNumber) || len(request.SizeCategoryID) != len(request.MaxNumber) {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "speciesId, sizeCategoryId, and maxNumber must be the same length",
		})
		return
	}

	var thumbnailURLs []string
	for _, thumbnail := range request.Thumbnails {
		filename := fmt.Sprintf("image/%s", helper.GenerateFileName(userID, filepath.Ext(thumbnail.Filename)))
		thumbnailURLs = append(thumbnailURLs, fmt.Sprintf("%s/%s", c.Request.Host, filename))

		if err := c.SaveUploadedFile(thumbnail, filename); err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Failed to save image",
				Error:   err.Error(),
			})
			return
		}
	}
	request.ThumbnailURLs = thumbnailURLs

	daycare, err := pdc.petDaycareService.CreatePetDaycare(userID, request)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to create pet daycare",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, daycare)
}

func (pdc *PetDaycareController) GetPetDaycares(c *gin.Context) {
	// Parse user GPS location
	userLat, err := strconv.ParseFloat(c.Query("lat"), 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid latitude",
			Error:   err.Error(),
		})
		return
	}

	userLng, err := strconv.ParseFloat(c.Query("long"), 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid longitude",
			Error:   err.Error(),
		})
		return
	}

	lastID, err := strconv.ParseUint(c.DefaultQuery("last-id", "0"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid last ID",
			Error:   err.Error(),
		})
		return
	}

	pageSize, err := strconv.Atoi(c.DefaultQuery("size", "10"))
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid page size",
			Error:   err.Error(),
		})
		return
	}

	// Parse filters
	var filters model.GetPetDaycaresRequest

	filters.Latitude = userLat
	filters.Longitude = userLng

	if minDist := c.DefaultQuery("min-distance", "0"); minDist != "" {
		value, _ := strconv.ParseFloat(minDist, 64)
		filters.MinDistance = &value
	}
	if maxDist := c.Query("max-distance"); maxDist != "" {
		value, err := strconv.ParseFloat(maxDist, 64)
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "max distance is required",
			Error:   err.Error(),
		})
		filters.MaxDistance = &value
	}
	if facilities := c.Query("facilities"); facilities != "" {
		filters.Facilities = strings.Split(facilities, ",")
	}
	if minPrice := c.DefaultQuery("min-price", "0"); minPrice != "" {
		value, _ := strconv.ParseFloat(minPrice, 64)
		filters.MinPrice = &value
	}
	if maxPrice := c.Query("max-price"); maxPrice != "" {
		value, _ := strconv.ParseFloat(maxPrice, 64)
		filters.MaxPrice = &value
	}
	if pricingType := c.DefaultQuery("pricing-type", "day"); pricingType != "" {
		filters.PricingType = &pricingType
	}

	if dailyWalksId := c.DefaultQuery("daily-walks", "1"); dailyWalksId != "" {
		value, _ := strconv.ParseUint(dailyWalksId, 10, 64)
		filters.DailyWalks = uint(value)
	}

	if dailyPlaytimeId := c.DefaultQuery("daily-playtime", "1"); dailyPlaytimeId != "" {
		value, _ := strconv.ParseUint(dailyPlaytimeId, 10, 64)
		filters.DailyPlaytime = uint(value)
	}

	// Call service
	daycares, err := pdc.petDaycareService.GetPetDaycares(filters, uint(lastID), pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to fetch pet daycares",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, daycares)
}

func (pdc *PetDaycareController) DeletePetDaycare(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "Unauthorized",
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

	petDaycareID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid pet daycare ID",
			Error:   err.Error(),
		})
		return
	}

	if err := pdc.petDaycareService.DeletePetDaycare(uint(petDaycareID), uint(userID)); err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to delete pet daycare",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (pdc *PetDaycareController) GetBookedPets(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "Unauthorized",
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

	petDaycareID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid pet daycare ID",
		})
		return
	}

	lastID, err := strconv.ParseUint(c.DefaultQuery("last-id", "0"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid last ID",
			Error:   err.Error(),
		})
		return
	}

	pageSize, err := strconv.Atoi(c.DefaultQuery("size", "10"))
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid page size",
			Error:   err.Error(),
		})
		return
	}

	out, err := pdc.petService.GetBookedPets(userID, uint(petDaycareID), uint(lastID), pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to fetch pets",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, out)
}

func (pdc *PetDaycareController) BookSlot(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "Unauthorized",
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

	var req model.BookSlotRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request data",
			Error:   err.Error(),
		})
		return
	}

	daycareId, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request data",
			Error:   err.Error(),
		})
		return
	}

	req.DaycareID = uint(daycareId)

	if err := pdc.slotService.BookSlots(userID, req); err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to book slots",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
