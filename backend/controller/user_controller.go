package controller

import (
	"errors"
	"fmt"
	"log"
	"net/http"
	"strconv"

	apputils "github.com/BryanEgbert/skripsi/app_utils"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type UserController struct {
	userService          service.UserService
	petService           service.PetService
	vaccineRecordService service.VaccineService
	petDaycareService    service.PetDaycareService
}

func NewUserController(userService service.UserService, petService service.PetService, vaccineRecordService service.VaccineService, petDaycareService service.PetDaycareService) *UserController {
	return &UserController{userService: userService, petService: petService, vaccineRecordService: vaccineRecordService, petDaycareService: petDaycareService}
}

func (uc *UserController) UpdateDeviceToken(c *gin.Context) {
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

	var req model.UpdateDeviceTokenRequest
	if err := c.ShouldBind(&req); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request body",
			Error:   err.Error(),
		})
		return
	}

	if err := uc.userService.UpdateDeviceToken(userID, req.DeviceToken); err != nil {
		if !errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Something went wrong",
				Error:   err.Error(),
			})
		}
	}

	c.JSON(http.StatusNoContent, nil)
}

func (uc *UserController) CreatePetDaycareProvider(c *gin.Context) {
	var req model.CreatePetDaycareProviderRequest

	profilePicture, err := c.FormFile("userProfilePicture")
	if err != nil {
		if !errors.Is(err, http.ErrMissingFile) {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "something's wrong",
				Error:   err.Error(),
			})
			log.Printf("Form file err: %v", err)
			return
		}
	}

	form, _ := c.MultipartForm()
	thumbnails := form.File["thumbnails[]"]

	if err := c.ShouldBind(&req); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request body",
			Error:   err.Error(),
		})
		log.Printf("JSON bind err: %v", err)
		return
	}

	log.Printf("petCategory: %v", req.PetCategoryID)

	req.RoleID = 2

	if profilePicture != nil {
		filePath, err := apputils.CompressImage(profilePicture)
		if err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Failed to save image",
				Error:   err.Error(),
			})
			return
		}

		imageUrl := fmt.Sprintf("http://%s/%s", c.Request.Host, filePath)

		req.UserImageUrl = imageUrl
	}

	createdUser, err := uc.userService.CreateUser(req.CreateUserRequest)
	if err != nil {
		c.JSON(http.StatusConflict, model.ErrorResponse{
			Message: "Failed to create new user",
			Error:   err.Error(),
		})
		log.Printf("Failed to create user: %v", err)
		return
	}

	if len(req.PetCategoryID) != len(req.MaxNumber) {
		log.Printf("Error: petCategoryId and maxNumber must be the same length")
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "petCategoryId and maxNumber must be the same length",
		})
		return
	}

	var thumbnailURLs []string

	for _, thumbnail := range thumbnails {
		filename, err := apputils.CompressImage(thumbnail)
		if err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Failed to save image",
				Error:   err.Error(),
			})
			return
		}
		thumbnailURLs = append(thumbnailURLs, fmt.Sprintf("http://%s/%s", c.Request.Host, filename))
	}
	req.ThumbnailURLs = thumbnailURLs

	if _, err := uc.petDaycareService.CreatePetDaycare(createdUser.UserID, req.CreatePetDaycareRequest); err != nil {
		log.Printf("create pet daycare err: %v", err)
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to create pet daycare",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, model.TokenResponse{
		UserID:       createdUser.UserID,
		RoleID:       2,
		AccessToken:  createdUser.AccessToken,
		RefreshToken: createdUser.RefreshToken,
		ExpiryDate:   createdUser.ExpiryDate,
	})
}

func (uc *UserController) CreatePetOwner(c *gin.Context) {
	var req model.CreatePetOwnerRequest

	profilePicture, err := c.FormFile("userProfilePicture")
	if err != nil {
		if !errors.Is(err, http.ErrMissingFile) {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "something's wrong",
				Error:   err.Error(),
			})
			log.Printf("Form file err: %v", err)
			return
		}

	}

	petProfilePicture, err := c.FormFile("petProfilePicture")
	if err != nil {
		if !errors.Is(err, http.ErrMissingFile) {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "something's wrong",
				Error:   err.Error(),
			})
			log.Printf("Form file err: %v", err)
			return
		}

	}

	vaccineRecordImage, err := c.FormFile("vaccineRecordImage")
	if err != nil {
		if !errors.Is(err, http.ErrMissingFile) {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "something's wrong",
				Error:   err.Error(),
			})
			log.Printf("Form file err: %v", err)
			return
		}
	}

	if err := c.ShouldBind(&req); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request body",
			Error:   err.Error(),
		})
		log.Printf("JSON bind err: %v", err)
		return
	}

	req.RoleID = 1

	if profilePicture != nil {

		filePath, err := apputils.CompressImage(profilePicture)
		if err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Failed to save image",
				Error:   err.Error(),
			})
			return
		}

		imageUrl := fmt.Sprintf("http://%s/%s", c.Request.Host, filePath)

		req.UserImageUrl = imageUrl
	}

	createdUser, err := uc.userService.CreateUser(req.CreateUserRequest)
	if err != nil {
		c.JSON(http.StatusConflict, model.ErrorResponse{
			Message: "Failed to create new user",
			Error:   err.Error(),
		})
		log.Printf("Failed to create user: %v", err)
		return
	}

	if petProfilePicture != nil {
		filePath, err := apputils.CompressImage(profilePicture)
		if err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Failed to save image",
				Error:   err.Error(),
			})
			return
		}

		imageUrl := fmt.Sprintf("http://%s/%s", c.Request.Host, filePath)
		req.PetImageUrl = &imageUrl
	}

	petID, err := uc.petService.CreatePet(createdUser.UserID, req.PetRequest)
	if err != nil {
		c.JSON(http.StatusConflict, model.ErrorResponse{
			Message: "Failed to create new pet",
			Error:   err.Error(),
		})
		log.Printf("Failed to create pet: %v", err)
		return
	}

	if vaccineRecordImage != nil {
		filePath, err := apputils.CompressImage(profilePicture)
		if err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Failed to save image",
				Error:   err.Error(),
			})
			return
		}

		imageUrl := fmt.Sprintf("http://%s/%s", c.Request.Host, filePath)
		req.VaccineRecordImageUrl = imageUrl

	}

	if req.DateAdministered != "" && req.NextDueDate != "" && vaccineRecordImage != nil {
		_, err = uc.vaccineRecordService.CreateVaccineRecords(petID, req.VaccineRecordRequest)
		if err != nil {
			c.JSON(http.StatusConflict, model.ErrorResponse{
				Message: "Failed to create new vaccine record",
				Error:   err.Error(),
			})
			log.Printf("Failed to create vaccine record: %v", err)
			return
		}
	}

	c.JSON(http.StatusCreated, model.TokenResponse{
		UserID:       createdUser.UserID,
		RoleID:       1,
		AccessToken:  createdUser.AccessToken,
		RefreshToken: createdUser.RefreshToken,
		ExpiryDate:   createdUser.ExpiryDate,
	})
}

func (uc *UserController) GetVets(c *gin.Context) {
	specialtyIdQuery := c.DefaultQuery("specialty-id", "0")
	var specialtyId uint64 = 0
	var err error

	specialtyId, err = strconv.ParseUint(specialtyIdQuery, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid specialty ID",
			Error:   err.Error(),
		})
		return
	}

	lastID, err := strconv.ParseUint(c.DefaultQuery("last-id", "0"), 10, 64)
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

	vets, err := uc.userService.GetVets(uint(specialtyId), uint(lastID), pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to get vets",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, model.ListData[model.UserDTO]{Data: vets})
}

func (uc *UserController) GetUser(c *gin.Context) {
	id, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid user ID",
			Error:   err.Error(),
		})
		return
	}

	user, err := uc.userService.GetUser(id)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, model.ErrorResponse{
				Message: "User not found",
				Error:   err.Error(),
			})
			return
		}

		c.JSON(http.StatusInternalServerError, model.ErrorResponse{
			Message: "Failed to fetch user",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, user)
}

func (uc *UserController) CreateUser(c *gin.Context) {
	var req model.CreateUserRequest

	profilePicture, err := c.FormFile("userProfilePicture")
	if err != nil {
		if !errors.Is(err, http.ErrMissingFile) {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "something's wrong",
				Error:   err.Error(),
			})
			log.Printf("Form file err: %v", err)
			return
		}

	}

	if err := c.ShouldBind(&req); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request body",
			Error:   err.Error(),
		})
		log.Printf("JSON bind err: %v", err)
		return
	}

	if req.RoleID == 3 {
		if req.VetSpecialtyID == nil || len(*req.VetSpecialtyID) == 0 {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{
				Message: "Vet specialty is required for vet role",
			})
			return
		}
	}

	if profilePicture != nil {

		filePath, err := apputils.CompressImage(profilePicture)
		if err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Failed to save image",
				Error:   err.Error(),
			})
			return
		}

		imageUrl := fmt.Sprintf("http://%s/%s", c.Request.Host, filePath)

		req.UserImageUrl = imageUrl
	}

	createdUser, err := uc.userService.CreateUser(req)
	if err != nil {
		c.JSON(http.StatusConflict, model.ErrorResponse{
			Message: "Failed to create new user",
			Error:   err.Error(),
		})
		log.Printf("Failed to create user: %v", err)
		return
	}

	c.JSON(http.StatusCreated, createdUser)
}

func (uc *UserController) DeleteUser(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "User ID not found in token",
		})
		return
	}

	err := uc.userService.DeleteUser(userID.(uint))
	if err != nil {
		c.JSON(http.StatusNotFound, model.ErrorResponse{
			Message: "Failed to delete user",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (uc *UserController) UpdateUserProfile(c *gin.Context) {
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

	profilePicture, err := c.FormFile("userProfilePicture")
	if err != nil {
		if !errors.Is(err, http.ErrMissingFile) {
			c.JSON(http.StatusBadRequest, model.ErrorResponse{
				Message: "Cannot get user profile picture",
				Error:   err.Error(),
			})
			return
		}
	}

	var req model.UpdateUserRequest
	if err := c.ShouldBind(&req); err != nil {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request body",
			Error:   err.Error(),
		})
		return
	}

	req.ID = userID

	if profilePicture != nil {

		filePath, err := apputils.CompressImage(profilePicture)
		if err != nil {
			c.JSON(http.StatusInternalServerError, model.ErrorResponse{
				Message: "Failed to save image",
				Error:   err.Error(),
			})
			return
		}

		imageUrl := fmt.Sprintf("http://%s/%s", c.Request.Host, filePath)

		req.ImageUrl = imageUrl
	}

	if err := uc.userService.UpdateUserProfile(&req); err != nil {
		c.JSON(http.StatusNotFound, model.ErrorResponse{
			Message: "Failed to update user profile",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

func (uc *UserController) UpdateUserPassword(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, model.ErrorResponse{
			Message: "User ID not found in token",
		})
		return
	}

	var req model.UpdatePasswordRequest

	if err := c.ShouldBindJSON(&req); err != nil || req.NewPassword == "" {
		c.JSON(http.StatusBadRequest, model.ErrorResponse{
			Message: "Invalid request body",
			Error:   err.Error(),
		})
		return
	}

	err := uc.userService.UpdateUserPassword(userID.(uint), req.NewPassword)
	if err != nil {
		c.JSON(http.StatusNotFound, model.ErrorResponse{
			Message: "Failed to update password",
			Error:   err.Error(),
		})
		return
	}

	c.Status(http.StatusNoContent)
}
