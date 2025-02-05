package controller

import (
	"fmt"
	"log"
	"net/http"
	"path/filepath"
	"strconv"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
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
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid pet ID"})
		return
	}

	pet, err := pc.petService.GetPet(uint(petID))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Pet not found"})
		return
	}

	c.JSON(http.StatusOK, pet)
}

// GetPets retrieves a paginated list of pets using cursor-based pagination
// GetPets retrieves a paginated list of pets belonging to the authenticated user
func (pc *PetController) GetPets(c *gin.Context) {
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

	lastID, err := strconv.ParseInt(c.Query("last-id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error(), "details": err.Error()})
		return
	}

	pageSize, err := strconv.Atoi(c.Query("size"))
	if err != nil || pageSize <= 0 {
		pageSize = 10 // Default page size
	}

	pets, err := pc.petService.GetPets(userID, lastID, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to retrieve pets", "details": err.Error()})
		return
	}

	c.JSON(http.StatusOK, pets)
}

func (pc *PetController) CreatePet(c *gin.Context) {
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

	var req model.PetRequest
	if err := c.Bind(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request data", "details": err.Error()})
		return
	}

	log.Print(req.Image.Filename)

	filename := fmt.Sprintf("image/%s", helper.GenerateFileName(userID, filepath.Ext(req.Image.Filename)))
	req.ImageUrl = fmt.Sprintf("%s/%s", c.Request.Host, filename)

	if err := c.SaveUploadedFile(req.Image, filename); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Upload file error", "details": err.Error()})
		return
	}

	pet, err := pc.petService.CreatePet(userID, req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create pet", "details": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, pet)
}

// UpdatePet updates a pet's information
func (pc *PetController) UpdatePet(c *gin.Context) {
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

	petID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid pet ID"})
		return
	}

	var req model.PetRequest
	if err := c.Bind(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request data"})
		return
	}

	filename := helper.GenerateFileName(userID, filepath.Ext(req.Image.Filename))
	req.ImageUrl = fmt.Sprintf("%s/image/%s", c.Request.Host, filename)

	if err := c.SaveUploadedFile(req.Image, filename); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Upload file error", "details": err.Error()})
		return
	}

	updatedPet, err := pc.petService.UpdatePet(uint(petID), model.PetDTO{
		Name:         req.Name,
		ImageUrl:     req.ImageUrl,
		Status:       req.Status,
		Species:      model.Species{ID: req.SpeciesID},
		SizeCategory: model.SizeCategory{ID: req.SizeCategoryID},
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update pet"})
		return
	}

	c.JSON(http.StatusOK, updatedPet)
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
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid pet ID", "details": err.Error()})
		return
	}

	// Delete pet only if it belongs to the authenticated user
	if err := pc.petService.DeletePet(uint(petID)); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Pet deleted successfully"})
}
