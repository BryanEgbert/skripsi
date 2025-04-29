package controller

import (
	"net/http"
	"strconv"

	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
)

type SlotController struct {
	slotService service.SlotService
}

func NewSlotController(slotService service.SlotService) *SlotController {
	return &SlotController{slotService: slotService}
}

func (s *SlotController) AcceptBookedSlot(c *gin.Context) {
	slotID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid slot ID",
		})

		return
	}

	if err := s.slotService.AcceptBookedSlot(uint(slotID)); err != nil {
		c.JSON(http.StatusNotFound, model.ErrorResponse{
			Message: "Failed to accept slot",
			Error:   err.Error(),
		})

		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (s *SlotController) RejectBookedSlot(c *gin.Context) {
	slotID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid slot ID",
		})

		return
	}

	if err := s.slotService.RejectBookedSlot(uint(slotID)); err != nil {
		c.JSON(http.StatusNotFound, model.ErrorResponse{
			Message: "Failed to reject slot",
			Error:   err.Error(),
		})

		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (s *SlotController) CancelBookedSlot(c *gin.Context) {
	slotID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid slot ID",
		})

		return
	}

	if err := s.slotService.CancelBookedSlot(uint(slotID)); err != nil {
		c.JSON(http.StatusNotFound, model.ErrorResponse{
			Message: "Failed to cancel slot",
			Error:   err.Error(),
		})

		return
	}

	c.JSON(http.StatusNoContent, nil)
}
