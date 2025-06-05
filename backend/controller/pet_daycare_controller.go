package controller

import (
	"errors"
	"fmt"
	"log"
	"net/http"
	"path/filepath"
	"strconv"
	"strings"

	apputils "github.com/BryanEgbert/skripsi/app_utils"
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

func (pdc *PetDaycareController) GetBookingRequests(ctx *gin.Context) {
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

	page, err := strconv.ParseInt(ctx.DefaultQuery("page", "1"), 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid last ID",
			Error:   err.Error(),
		})
		return
	}

	pageSize, err := strconv.Atoi(ctx.DefaultQuery("size", "10"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid page size",
			Error:   err.Error(),
		})
		return
	}

	out, err := pdc.slotService.GetBookingRequests(userID, int(page), pageSize)

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to retrieve booking requests",
			Error:   err.Error(),
		})
		return
	}

	ctx.JSON(http.StatusOK, out)
}

func (pdc *PetDaycareController) GetReviews(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "Unauthorized",
		})
		return
	}

	userID, ok := userIDRaw.(uint)
	if !ok {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
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

	// Get optional pagination parameters
	rawPage := c.Query("page")
	var page uint64 = 0
	if rawPage != "" {
		page, err = strconv.ParseUint(rawPage, 10, 64)
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
	reviews, err := pdc.reviewService.GetReviews(userID, uint(petDaycareID), int(page), pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to retrieve reviews",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, model.ListData[model.ReviewsDTO]{Data: *reviews})
}

func (pdc *PetDaycareController) GetBookedPetOwners(c *gin.Context) {
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

	page, err := strconv.ParseInt(c.DefaultQuery("page", "1"), 10, 64)
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

	out, err := pdc.petDaycareService.GetBookedPetOwners(userID, int(page), pageSize)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, model.ErrorResponse{
				Message: "Pet Daycare does not exists",
				Error:   err.Error(),
			})
			return
		} else {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Something's wrong, please try again later",
				Error:   err.Error(),
			})
			return
		}
	}

	c.JSON(http.StatusOK, out)
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

func (pdc *PetDaycareController) GetReducedSlots(c *gin.Context) {
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

	page, err := strconv.ParseInt(c.DefaultQuery("page", "1"), 10, 64)
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

	out, err := pdc.slotService.GetReducedSlot(userID, int(page), pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "something's wrong, please try again later",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, model.ListData[model.ReduceSlotsDTO]{Data: out})
}

func (pdc *PetDaycareController) GetPetDaycareSlots(c *gin.Context) {
	var petCategoryIds []uint
	petCategoryIdRaw := c.Query("pet-category")
	if petCategoryIdRaw == "" {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Missing pet category",
		})
		return
	}

	for _, val := range strings.Split(petCategoryIdRaw, ",") {
		petCategoryId, err := strconv.ParseInt(val, 10, 64)
		if err != nil {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{
				Message: "Invalid pet category",
				Error:   err.Error(),
			})
			return
		}

		petCategoryIds = append(petCategoryIds, uint(petCategoryId))
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
		PetCategoryID: petCategoryIds,
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

	var latitude *float64 = nil
	var longitude *float64 = nil

	if c.Query("lat") != "" {
		value, err := strconv.ParseFloat(c.Query("lat"), 64)
		if err != nil {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{
				Message: "Invalid latitude",
				Error:   err.Error(),
			})
			return
		}

		latitude = &value
	}

	if c.Query("long") != "" {
		value, err := strconv.ParseFloat(c.Query("long"), 64)
		if err != nil {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{
				Message: "Invalid longitude",
				Error:   err.Error(),
			})
			return
		}

		longitude = &value
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
		log.Printf("parse pet daycare id err: %v", err)
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid pet daycare ID",
		})
		return
	}

	var request model.UpdatePetDaycareRequest
	if err := c.ShouldBind(&request); err != nil {
		log.Printf("Bind err: %v", err)
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request data",
			Error:   err.Error(),
		})
		return
	}

	if len(request.PetCategoryID) != len(request.MaxNumber) {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "petCategoryId and maxNumber must be the same length",
		})
		return
	}

	// var thumbnailURLs []string
	// for _, thumbnail := range request.Thumbnails {
	// 	if thumbnail != nil {
	// 		filename := fmt.Sprintf("image/%s", helper.GenerateFileName(userID, filepath.Ext(thumbnail.Filename)))
	// 		// TODO: change url scheme?
	// 		thumbnailURLs = append(thumbnailURLs, fmt.Sprintf("http://%s/%s", c.Request.Host, filename))

	// 		if err := c.SaveUploadedFile(thumbnail, filename); err != nil {
	// 			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
	// 				Message: "Failed to save image",
	// 				Error:   err.Error(),
	// 			})
	// 			return
	// 		}
	// 	}
	// }
	// request.ThumbnailURLs = thumbnailURLs
	log.Printf("thumbnail: %d", len(request.ThumbnailURLs))
	_, err = pdc.petDaycareService.UpdatePetDaycare(uint(petDaycareID), userID, request)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to update pet daycare",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusNoContent, nil)
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

	if len(request.PetCategoryID) != len(request.MaxNumber) {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "petCategoryId and maxNumber must be the same length",
		})
		return
	}

	var thumbnailURLs []string
	for _, thumbnail := range request.Thumbnails {
		filename := fmt.Sprintf("image/%s", helper.GenerateFileName(userID, filepath.Ext(thumbnail.Filename)))
		thumbnailURLs = append(thumbnailURLs, fmt.Sprintf("http://%s/%s", c.Request.Host, filename))

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

func (pdc *PetDaycareController) GetMyPetdaycare(c *gin.Context) {
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

	out, err := pdc.petDaycareService.GetMyPetDaycare(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to fetch data",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, out)
}

func (pdc *PetDaycareController) GetPetDaycares(c *gin.Context) {
	// Parse user GPS location
	var filters model.GetPetDaycaresRequest

	if userLat := c.Query("lat"); userLat != "" {
		value, err := strconv.ParseFloat(c.Query("lat"), 64)
		if err != nil {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{
				Message: "Invalid latitude",
				Error:   err.Error(),
			})
			return
		}

		filters.Latitude = &value
	}

	if userLng := c.Query("long"); userLng != "" {
		value, err := strconv.ParseFloat(c.Query("long"), 64)
		if err != nil {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{
				Message: "Invalid longitude",
				Error:   err.Error(),
			})
			return
		}

		filters.Longitude = &value
	}

	page, err := strconv.ParseInt(c.DefaultQuery("page", "1"), 10, 64)
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

	if minDist := c.DefaultQuery("min-distance", "0"); minDist != "" {
		value, _ := strconv.ParseFloat(minDist, 64)
		filters.MinDistance = value
	}
	if maxDist := c.DefaultQuery("max-distance", "0"); maxDist != "" {
		value, err := strconv.ParseFloat(maxDist, 64)
		if err != nil {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{
				Message: "max distance is required",
				Error:   err.Error(),
			})
			return
		}
		filters.MaxDistance = value
	}
	if petCategoryIds := c.Query("pet-categories"); petCategoryIds != "" {
		splitted := strings.Split(petCategoryIds, ",")
		for _, val := range splitted {
			value, _ := strconv.ParseUint(val, 10, 64)
			filters.PetCategoryIds = append(filters.PetCategoryIds, uint(value))
		}
	}
	if facilities := c.Query("facilities"); facilities != "" {
		filters.Facilities = strings.Split(facilities, ",")
	}
	if minPrice := c.DefaultQuery("min-price", "0"); minPrice != "" {
		value, _ := strconv.ParseFloat(minPrice, 64)
		filters.MinPrice = value
	}
	if maxPrice := c.DefaultQuery("max-price", "0"); maxPrice != "" {
		value, _ := strconv.ParseFloat(maxPrice, 64)
		filters.MaxPrice = value
	}
	if pricingType := c.Query("pricing-type"); pricingType != "" {
		value, _ := strconv.ParseUint(pricingType, 10, 64)
		valueUint := uint(value)
		filters.PricingType = &valueUint
	}

	if dailyWalksId := c.DefaultQuery("daily-walks", "0"); dailyWalksId != "" {
		value, _ := strconv.ParseUint(dailyWalksId, 10, 64)
		valueUint := uint(value)
		filters.DailyWalks = valueUint
	}

	if dailyPlaytimeId := c.DefaultQuery("daily-playtime", "0"); dailyPlaytimeId != "" {
		value, _ := strconv.ParseUint(dailyPlaytimeId, 10, 64)
		valueUint := uint(value)
		filters.DailyPlaytime = valueUint
	}

	if mustBeVaccinated := c.Query("vaccination-required"); mustBeVaccinated != "" {
		value, err := strconv.ParseBool(mustBeVaccinated)
		if err != nil {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{
				Message: "Invalid value for vaccination-required",
				Error:   err.Error(),
			})
			return
		}

		filters.MustBeVaccinated = &value
	}

	// Call service
	daycares, err := pdc.petDaycareService.GetPetDaycares(filters, int(page), pageSize)
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

	out, err := pdc.petService.GetBookedPets(userID, uint(lastID), pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to fetch pets",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, model.ListData[model.PetDTO]{Data: *out})
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
	if err := c.ShouldBind(&req); err != nil {
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
		if errors.Is(err, apputils.ErrOnlyOneSlotDate) || errors.Is(err, apputils.ErrSlotFull) || errors.Is(err, apputils.ErrPetAlreadyBooked) {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: err.Error(),
			})
			return
		}

		log.Printf("Book Slots err: %v", err)

		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to book slots",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, nil)
}
