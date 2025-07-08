package controller

import (
	"fmt"
	"log"
	"net/http"

	apputils "github.com/BryanEgbert/skripsi/app_utils"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
)

type ImageController struct {
	imageService service.ImageService
}

func NewImageController(imageService service.ImageService) *ImageController {
	return &ImageController{imageService: imageService}
}

func (c *ImageController) Upload(ctx *gin.Context) {
	file, err := ctx.FormFile("image")
	if err != nil {
		ctx.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request body",
			Error:   err.Error(),
		})
		log.Printf("JSON bind err: %v", err)
		return
	}

	filePath, err := apputils.CompressImage(file)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to save image",
			Error:   err.Error(),
		})
		return
	}

	imageUrl := fmt.Sprintf("http://%s/%s", ctx.Request.Host, filePath)

	ctx.JSON(http.StatusCreated, gin.H{"imageUrl": imageUrl})
}
