package controller

import (
	"net/http"
	"strconv"

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

func (vc *VaccineRecordController) GetVaccineRecords(c *gin.Context) {
	petID, err := strconv.ParseUint(c.Param("petId"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid pet ID",
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

	records, err := vc.vaccineRecordService.GetVaccineRecords(uint(petID), uint(lastID), pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong",
			Error:   err.Error(),
		})

		return
	}

	c.JSON(http.StatusOK, model.ListData[model.VaccineRecordDTO]{Data: *records})
}
