package controller

import (
	"fmt"
	"net/http"
	"path/filepath"
	"strconv"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
)

type VaccineRecordController struct {
	vaccineRecordService service.VaccineService
}

func NewVaccineRecordController(vaccineRecordService service.VaccineService) *VaccineRecordController {
	return &VaccineRecordController{vaccineRecordService: vaccineRecordService}
}

func (vc *VaccineRecordController) GetVaccineRecord(c *gin.Context) {
	vaccineRecordId, err := strconv.ParseUint(c.Param("vaccineRecordId"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid ID",
		})

		return
	}

	out, err := vc.vaccineRecordService.GetVaccineRecord(uint(vaccineRecordId))
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to fetch data",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, out)
}

func (vc *VaccineRecordController) UpdateVaccineRecords(c *gin.Context) {
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

	vaccineRecordId, err := strconv.ParseUint(c.Param("vaccineRecordId"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid ID",
		})

		return
	}

	var req model.VaccineRecordRequest
	if err := c.Bind(&req); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request data",
			Error:   err.Error(),
		})
		return
	}

	if req.VaccineRecordImage != nil {
		filename := fmt.Sprintf("image/%s", helper.GenerateFileName(userID, filepath.Ext(req.VaccineRecordImage.Filename)))
		imageUrl := fmt.Sprintf("%s/%s", c.Request.Host, filename)
		req.VaccineRecordImageUrl = imageUrl

		if err := c.SaveUploadedFile(req.VaccineRecordImage, filename); err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Failed to save image",
				Error:   err.Error(),
			})
			return
		}
	}

	if err := vc.vaccineRecordService.UpdateVaccineRecord(uint(vaccineRecordId), req); err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to update vaccination record",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (vc *VaccineRecordController) DeleteVaccineRecords(c *gin.Context) {
	vaccineRecordId, err := strconv.ParseUint(c.Param("vaccineRecordId"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid ID",
		})

		return
	}

	if err := vc.vaccineRecordService.DeleteVaccineRecords(uint(vaccineRecordId)); err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to delete vaccine record",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (vc *VaccineRecordController) CreateVaccineRecords(c *gin.Context) {
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
		})

		return
	}

	var req model.VaccineRecordRequest
	if err := c.Bind(&req); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request data",
			Error:   err.Error(),
		})
		return
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

	if _, err = vc.vaccineRecordService.CreateVaccineRecords(uint(petID), req); err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to create vaccination record",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, nil)
}

func (vc *VaccineRecordController) GetVaccineRecords(c *gin.Context) {
	petID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid pet ID",
		})

		return
	}

	page, err := strconv.ParseInt(c.DefaultQuery("page", "1"), 10, 64)
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

	records, err := vc.vaccineRecordService.GetVaccineRecords(uint(petID), int(page), pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong",
			Error:   err.Error(),
		})

		return
	}

	c.JSON(http.StatusOK, model.ListData[model.VaccineRecordDTO]{Data: *records})
}
