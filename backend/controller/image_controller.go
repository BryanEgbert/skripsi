package controller

import (
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"path/filepath"

	"github.com/BryanEgbert/skripsi/helper"
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
	// userIDRaw, exists := ctx.Get("userID")
	// if !exists {
	// 	ctx.JSON(http.StatusUnauthorized, model.ErrorResponse{
	// 		Message: "Unauthorized",
	// 	})
	// 	return
	// }

	// userID, ok := userIDRaw.(uint)
	// if !ok {
	// 	ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
	// 		Message: "Invalid user ID",
	// 	})
	// 	return
	// }

	// var req model.ChatImageRequest
	file, err := ctx.FormFile("image")
	if err != nil {
		ctx.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request body",
			Error:   err.Error(),
		})
		log.Printf("JSON bind err: %v", err)
		return
	}

	filename := fmt.Sprintf("image/%s", helper.GenerateFileName(uint(rand.Uint64()), filepath.Ext(file.Filename)))
	imageUrl := fmt.Sprintf("http://%s/%s", ctx.Request.Host, filename)

	log.Printf("imageUrl: %v", gin.H{"imageUrl": imageUrl})

	if err := ctx.SaveUploadedFile(file, filename); err != nil {
		ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to save image",
			Error:   err.Error(),
		})
		return
	}

	// url, err := c.imageService.Upload(imageUrl)
	// if err != nil {
	// 	ctx.JSON(http.StatusInternalServerError, model.ErrorResponse{
	// 		Message: "Failed to upload image",
	// 		Error:   err.Error(),
	// 	})
	// 	return
	// }

	ctx.JSON(http.StatusCreated, gin.H{"imageUrl": imageUrl})
}
