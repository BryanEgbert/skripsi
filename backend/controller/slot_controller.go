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

func (tc *SlotController) GetBookedSlot(c *gin.Context) {
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

	transactionID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid transaction ID",
		})
		return
	}

	out, err := tc.slotService.GetBookedSlot(uint(transactionID), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to fetch booking history",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, out)
}

func (tc *SlotController) GetBookedSlots(c *gin.Context) {
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

	out, err := tc.slotService.GetBookedSlots(userID, int(page), pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to fetch booking histories",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, model.ListData[model.BookedSlotDTO]{Data: *out})
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

func (pdc *SlotController) EditSlotCount(c *gin.Context) {
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

	if err := pdc.slotService.EditSlotCount(userID, uint(slotID), req); err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Cannot edit slot count",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, nil)
}

func (pdc *SlotController) DeleteReducedSlot(ctx *gin.Context) {
	slotIDRaw := ctx.Param("slotId")
	if slotIDRaw == "" {
		ctx.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "slot ID missing",
		})
		return
	}

	slotID, err := strconv.ParseUint(slotIDRaw, 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid last ID",
			Error:   err.Error(),
		})
		return
	}
	if err := pdc.slotService.DeleteReducedSlot(uint(slotID)); err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to reduce slot",
			Error:   err.Error(),
		})
		return
	}

	ctx.JSON(http.StatusNoContent, nil)
}
