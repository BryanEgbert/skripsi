package controller

import (
	"errors"
	"fmt"
	"net/http"
	"path/filepath"
	"strconv"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type PetController struct {
	petService service.PetService
}

func NewPetController(petService service.PetService) *PetController {
	return &PetController{petService}
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

// GetPets retrieves a paginated list of pets using cursor-based pagination
// GetPets retrieves a paginated list of pets belonging to the authenticated user
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

	var req model.PetRequest
	if err := c.Bind(&req); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request data",
			Error:   err.Error(),
		})
		return
	}

	filename := fmt.Sprintf("image/%s", helper.GenerateFileName(userID, filepath.Ext(req.Image.Filename)))
	req.ImageUrl = fmt.Sprintf("%s/%s", c.Request.Host, filename)

	if err := c.SaveUploadedFile(req.Image, filename); err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to save image",
			Error:   err.Error(),
		})
		return
	}

	if err := pc.petService.CreatePet(userID, req); err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to create pet",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, nil)
}

// UpdatePet updates a pet's information
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

	filename := fmt.Sprintf("image/%s", helper.GenerateFileName(userID, filepath.Ext(req.Image.Filename)))
	req.ImageUrl = fmt.Sprintf("%s/%s", c.Request.Host, filename)

	if err := c.SaveUploadedFile(req.Image, filename); err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Upload image error",
			Error:   err.Error(),
		})
		return
	}

	if err := pc.petService.UpdatePet(uint(petID), model.PetDTO{
		Name:         req.Name,
		ImageUrl:     req.ImageUrl,
		Status:       req.Status,
		Species:      model.Species{ID: req.SpeciesID},
		SizeCategory: model.SizeCategory{ID: req.SizeCategoryID},
	}); err != nil {
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
	// userIDRaw, exists := c.Get("userID")
	// if !exists {
	// 	c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
	// 	return
	// }

	// userID, ok := userIDRaw.(uint)
	// if !ok {
	// 	c.JSON(http.StatusForbidden, gin.H{"error": "Invalid user ID"})
	// 	return
	// }

	petID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid pet ID",
			Error:   err.Error(),
		})
		return
	}

	// Delete pet only if it belongs to the authenticated user
	if err := pc.petService.DeletePet(uint(petID)); err != nil {
		c.JSON(http.StatusNotFound, model.ErrorResponse{
			Message: "Failed to delete pet",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
