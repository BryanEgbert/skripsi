package controller

import (
	"log"
	"net/http"
	"strconv"

	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
)

type SavedAddressController struct {
	savedAddressService service.SavedAddressService
}

func NewSavedAddressController(savedAddressService service.SavedAddressService) *SavedAddressController {
	return &SavedAddressController{savedAddressService: savedAddressService}
}

func (s *SavedAddressController) DeleteSavedAddress(c *gin.Context) {
	addressID, err := strconv.ParseUint(c.Param("addressId"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid address ID",
			Error:   err.Error(),
		})
		return
	}

	if err := s.savedAddressService.DeleteSavedAddress(uint(addressID)); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Something's wrong, please try again later",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (s *SavedAddressController) EditSavedAddress(c *gin.Context) {
	addressID, err := strconv.ParseUint(c.Param("addressId"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid address ID",
			Error:   err.Error(),
		})
		return
	}

	var req model.CreateSavedAddress
	if err := c.ShouldBind(&req); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request body",
			Error:   err.Error(),
		})
		log.Printf("JSON bind err: %v", err)
		return
	}

	if err := s.savedAddressService.EditSavedAddress(uint(addressID), req); err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong when adding address",
			Error:   err.Error(),
		})
		log.Printf("AddSavedAddress err: %v", err)
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (s *SavedAddressController) GetSavedAddress(c *gin.Context) {
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

	out, err := s.savedAddressService.GetSavedAddress(userID, int(page), pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong, please try again later",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, model.ListData[model.SavedAddressDTO]{Data: out})
}

func (s *SavedAddressController) AddSavedAddress(c *gin.Context) {
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

	var req model.CreateSavedAddress
	if err := c.ShouldBind(&req); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request body",
			Error:   err.Error(),
		})
		log.Printf("JSON bind err: %v", err)
		return
	}

	if err := s.savedAddressService.AddSavedAddress(userID, req); err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong when adding address",
			Error:   err.Error(),
		})
		log.Printf("AddSavedAddress err: %v", err)
		return
	}

	c.JSON(http.StatusCreated, nil)
}
