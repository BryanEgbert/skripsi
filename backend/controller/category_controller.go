package controller

import (
	"net/http"

	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
)

type CategoryController struct {
	categoryService service.CategoryService
}

func NewCategoryController(categoryService service.CategoryService) *CategoryController {
	return &CategoryController{categoryService: categoryService}
}

func (c *CategoryController) GetVetSpecialties(ctx *gin.Context) {
	res, err := c.categoryService.GetVetSpecialties()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong, please try again later",
			Error: err.Error(),
		})

		return
	}

	ctx.JSON(http.StatusOK, model.ListData[model.VetSpecialty]{Data: *res})
}

func (c *CategoryController) GetPetCategories(ctx *gin.Context) {
	res, err := c.categoryService.GetPetCategories()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong, please try again later",
			Error: err.Error(),
		})

		return
	}

	ctx.JSON(http.StatusOK, model.ListData[model.PetCategoryDTO]{Data: *res})
}

func (c *CategoryController) GetSizeCategories(ctx *gin.Context) {
	res, err := c.categoryService.GetSizeCategories()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong, please try again later",
			Error: err.Error(),
		})

		return
	}

	ctx.JSON(http.StatusOK, model.ListData[model.SizeCategory]{Data: *res})
}

func (c *CategoryController) GetDailyWalks(ctx *gin.Context) {
	res, err := c.categoryService.GetDailyWalks()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong, please try again later",
			Error: err.Error(),
		})

		return
	}

	ctx.JSON(http.StatusOK, model.ListData[model.DailyWalks]{Data: *res})
}

func (c *CategoryController) GetDailyPlaytime(ctx *gin.Context) {
	res, err := c.categoryService.GetDailyPlaytime()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong, please try again later",
			Error: err.Error(),
		})

		return
	}

	ctx.JSON(http.StatusOK, model.ListData[model.DailyPlaytime]{Data: *res})
}