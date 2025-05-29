package controller

import (
	"errors"
	"fmt"
	"log"
	"net/http"
	"path/filepath"
	"strconv"

	apputils "github.com/BryanEgbert/skripsi/app_utils"
	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type PetController struct {
	petService           service.PetService
	vaccineRecordService service.VaccineService
}

func NewPetController(petService service.PetService, vaccineRecordService service.VaccineService) *PetController {
	return &PetController{petService, vaccineRecordService}
}

// GetPet retrieves a single pet by ID
func (pc *PetController) GetPet(c *gin.Context) {
	petID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid pet ID",
		})

		return
	}

	pet, err := pc.petService.GetPet(uint(petID))
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, model.ErrorResponse{
				Message: "Pet not found",
			})

			return
		}

		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong",
			Error:   err.Error(),
		})

		return
	}

	c.JSON(http.StatusOK, pet)
}

func (pc *PetController) GetPets(c *gin.Context) {
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

	lastID, err := strconv.ParseUint(c.DefaultQuery("last-id", "0"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid start ID",
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

	pets, err := pc.petService.GetPets(userID, uint(lastID), pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to retrieve pets",
			Error:   err.Error(),
		})
		return
	}

	log.Printf("pets: %v", *pets)

	c.JSON(http.StatusOK, model.ListData[model.PetDTO]{Data: *pets})
}

func (pc *PetController) CreatePet(c *gin.Context) {
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

	var req model.PetAndVaccinationRecordRequest
	if err := c.Bind(&req); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request data",
			Error:   err.Error(),
		})
		return
	}

	if req.PetImage != nil {
		filename := fmt.Sprintf("image/%s", helper.GenerateFileName(userID, filepath.Ext(req.PetImage.Filename)))
		imageUrl := fmt.Sprintf("%s/%s", c.Request.Host, filename)
		req.PetImageUrl = &imageUrl

		if err := c.SaveUploadedFile(req.PetImage, filename); err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Failed to save image",
				Error:   err.Error(),
			})
			return
		}
	}

	if req.VaccineRecordImage != nil {
		filename := fmt.Sprintf("image/%s", helper.GenerateFileName(userID, filepath.Ext(req.VaccineRecordImage.Filename)))
		imageUrl := fmt.Sprintf("http://%s/%s", c.Request.Host, filename)
		req.VaccineRecordImageUrl = imageUrl

		if err := c.SaveUploadedFile(req.VaccineRecordImage, filename); err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Failed to save image",
				Error:   err.Error(),
			})
			return
		}
	}

	petID, err := pc.petService.CreatePet(userID, req.PetRequest)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to create pet",
			Error:   err.Error(),
		})
		return
	}

	if req.DateAdministered != nil && req.NextDueDate != nil && req.VaccineRecordImage != nil {
		if _, err = pc.vaccineRecordService.CreateVaccineRecords(petID, model.VaccineRecordRequest{
			DateAdministered:      *req.DateAdministered,
			NextDueDate:           *req.NextDueDate,
			VaccineRecordImage:    req.VaccineRecordImage,
			VaccineRecordImageUrl: req.VaccineRecordImageUrl,
		}); err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Failed to create vaccination record",
				Error:   err.Error(),
			})
			return
		}
	}

	c.JSON(http.StatusCreated, nil)
}

func (pc *PetController) UpdatePet(c *gin.Context) {
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

	petID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid pet ID",
			Error:   err.Error(),
		})
		return
	}

	var req model.PetRequest
	if err := c.Bind(&req); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request data",
			Error:   err.Error(),
		})
		return
	}

	if req.PetImage != nil {
		filename := fmt.Sprintf("image/%s", helper.GenerateFileName(userID, filepath.Ext(req.PetImage.Filename)))
		imageUrl := fmt.Sprintf("http://%s/%s", c.Request.Host, filename)
		req.PetImageUrl = &imageUrl

		log.Printf("pet image: %s", *req.PetImageUrl)
		if err := c.SaveUploadedFile(req.PetImage, filename); err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Upload image error",
				Error:   err.Error(),
			})
			return
		}
	}

	dto := model.PetDTO{
		Name:        req.Name,
		Status:      req.Status,
		PetCategory: model.PetCategoryDTO{ID: req.PetCategoryID},
	}

	if req.PetImageUrl != nil {
		dto.ImageUrl = *req.PetImageUrl
	}

	if err := pc.petService.UpdatePet(uint(petID), dto); err != nil {
		c.JSON(http.StatusNotFound, model.ErrorResponse{
			Message: "Failed to update pet",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// DeletePet deletes a pet
func (pc *PetController) DeletePet(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	userID, ok := userIDRaw.(uint)
	if !ok {
		c.JSON(http.StatusForbidden, gin.H{"error": "Invalid user ID"})
		return
	}

	petID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid pet ID",
			Error:   err.Error(),
		})
		return
	}

	// Delete pet only if it belongs to the authenticated user
	if err := pc.petService.DeletePet(uint(petID), userID); err != nil {
		if errors.Is(err, apputils.ErrOnlyOnePet) {
			c.JSON(http.StatusForbidden, model.ErrorResponse{
				Message: "You cannot delete the last remaining pet",
				Error:   err.Error(),
			})
			return
		}

		c.JSON(http.StatusNotFound, model.ErrorResponse{
			Message: "Failed to delete pet",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
