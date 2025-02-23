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

	ctx.JSON(http.StatusOK, gin.H{"data": res})
}

func (c *CategoryController) GetSpecies(ctx *gin.Context) {
	res, err := c.categoryService.GetSpecies()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Something's wrong, please try again later",
			Error: err.Error(),
		})

		return
	}

	ctx.JSON(http.StatusOK, gin.H{"data": res})
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

	ctx.JSON(http.StatusOK, gin.H{"data": res})
}