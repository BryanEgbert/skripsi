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

func (c *CategoryController) GetPricingType(ctx *gin.Context) {
	lang := ctx.DefaultQuery("language", "en")
	res, err := c.categoryService.GetPricingType(lang)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong, please try again later",
			Error:   err.Error(),
		})

		return
	}

	ctx.JSON(http.StatusOK, model.ListData[model.PricingType]{Data: *res})
}

func (c *CategoryController) GetVetSpecialties(ctx *gin.Context) {
	lang := ctx.DefaultQuery("language", "en")
	res, err := c.categoryService.GetVetSpecialties(lang)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong, please try again later",
			Error:   err.Error(),
		})

		return
	}

	ctx.JSON(http.StatusOK, model.ListData[model.VetSpecialty]{Data: *res})
}

func (c *CategoryController) GetPetCategories(ctx *gin.Context) {
	lang := ctx.DefaultQuery("language", "en")
	res, err := c.categoryService.GetPetCategories(lang)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong, please try again later",
			Error:   err.Error(),
		})

		return
	}

	ctx.JSON(http.StatusOK, model.ListData[model.PetCategoryDTO]{Data: *res})
}

func (c *CategoryController) GetSizeCategories(ctx *gin.Context) {
	lang := ctx.DefaultQuery("language", "en")
	res, err := c.categoryService.GetSizeCategories(lang)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong, please try again later",
			Error:   err.Error(),
		})

		return
	}

	ctx.JSON(http.StatusOK, model.ListData[model.SizeCategory]{Data: *res})
}

func (c *CategoryController) GetDailyWalks(ctx *gin.Context) {
	lang := ctx.DefaultQuery("language", "en")
	res, err := c.categoryService.GetDailyWalks(lang)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong, please try again later",
			Error:   err.Error(),
		})

		return
	}

	ctx.JSON(http.StatusOK, model.ListData[model.DailyWalks]{Data: *res})
}

func (c *CategoryController) GetDailyPlaytime(ctx *gin.Context) {
	lang := ctx.DefaultQuery("language", "en")
	res, err := c.categoryService.GetDailyPlaytime(lang)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong, please try again later",
			Error:   err.Error(),
		})

		return
	}

	ctx.JSON(http.StatusOK, model.ListData[model.DailyPlaytime]{Data: *res})
}
