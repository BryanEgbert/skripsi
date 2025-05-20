package service

import (
	"errors"
	"os"
	"time"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type UserService interface {
	GetUser(id int64) (*model.UserDTO, error)
	GetVets(vetSpecialtyId uint, startId uint, pageSize int) ([]model.UserDTO, error)
	CreateUser(user model.CreateUserRequest) (*model.TokenResponse, error)
	DeleteUser(id uint) error
	UpdateUserProfile(user *model.UpdateUserRequest) error
	UpdateUserPassword(id uint, newPassword string) error
	GetDeviceToken(userId uint) (*string, error)
}

type UserServiceImpl struct {
	db *gorm.DB
}

func NewUserService(db *gorm.DB) *UserServiceImpl {
	return &UserServiceImpl{db: db}
}

func (s *UserServiceImpl) GetDeviceToken(userId uint) (*string, error) {
	var token *string

	if err := s.db.
		Model(&model.User{}).
		Where("id = ?", userId).
		Select("device_token").
		Scan(&token).Error; err != nil {
		return nil, err
	}

	return token, nil
}

func (s *UserServiceImpl) GetVets(vetSpecialtyId uint, startId uint, pageSize int) ([]model.UserDTO, error) {
	// var users []model.User
	out := []model.UserDTO{}

	if vetSpecialtyId == 0 {
		rows, err := s.db.
			Table("users").
			Select("users.id", "users.name", "email", "image_url", "roles.id", "roles.name", "users.created_at").
			Preload("VetSpecialty").
			Joins("JOIN roles ON roles.id = users.role_id").Where("roles.id = 3").Rows()
		if err != nil {
			return nil, err
		}
		defer rows.Close()

		for rows.Next() {
			var user model.UserDTO
			var vetSpecialties []model.VetSpecialty

			rows.Scan(&user.ID, &user.Name, &user.Email, &user.ImageUrl, &user.Role.ID, &user.Role.Name, &user.CreatedAt)

			if err := s.db.
				Table("vet_specialties").
				Select("id", "name").
				Joins("JOIN user_vet_specialties AS uvs ON vet_specialties.id = uvs.vet_specialty_id").
				Where("user_id = ?", user.ID).
				Find(&vetSpecialties).Error; err != nil {
				return nil, err
			}

			user.VetSpecialty = vetSpecialties
			out = append(out, user)
		}
	} else {
		rows, err := s.db.
			Table("users").
			Select("users.id", "users.name", "email", "image_url", "roles.id", "roles.name", "users.created_at").
			Joins("JOIN roles ON roles.id = users.role_id").
			Joins("JOIN	user_vet_specialties AS uvs ON uvs.user_id = users.id").
			Preload("VetSpecialty").
			Where("roles.id = 3 AND uvs.vet_specialty_id = ?", vetSpecialtyId).Rows()
		if err != nil {
			return nil, err
		}
		defer rows.Close()

		for rows.Next() {
			var user model.UserDTO
			var vetSpecialties []model.VetSpecialty

			rows.Scan(&user.ID, &user.Name, &user.Email, &user.ImageUrl, &user.Role.ID, &user.Role.Name, &user.CreatedAt)

			if err := s.db.
				Table("vet_specialties").
				Select("id", "name").
				Joins("JOIN user_vet_specialties AS uvs ON vet_specialties.id = uvs.vet_specialty_id").
				Where("user_id = ?", user.ID).
				Find(&vetSpecialties).Error; err != nil {
				return nil, err
			}

			user.VetSpecialty = vetSpecialties
			out = append(out, user)
		}
	}

	return out, nil
}

func (s *UserServiceImpl) GetUser(id int64) (*model.UserDTO, error) {
	var user model.User
	if err := s.db.Preload("VetSpecialty").Joins("Role").First(&user, id).Error; err != nil {
		return nil, err
	}

	userDTO := helper.ConvertUserToDTO(user)

	return &userDTO, nil
}

func (s *UserServiceImpl) CreateUser(request model.CreateUserRequest) (*model.TokenResponse, error) {
	hashedPassword, err := helper.HashPassword(request.Password)
	if err != nil {
		return nil, err
	}

	user := model.User{
		Name:        request.Name,
		Email:       request.Email,
		Password:    hashedPassword,
		RoleID:      request.RoleID,
		ImageUrl:    &request.UserImageUrl,
		DeviceToken: request.DeviceToken,
	}

	// Validate Role exists
	var roleExists bool
	if err := s.db.Model(&model.Role{}).Select("count(*) > 0").
		Where("id = ?", request.RoleID).
		Find(&roleExists).Error; err != nil {
		return nil, err
	}
	if !roleExists {
		return nil, errors.New("invalid role ID")
	}

	// Vet role validation (VetSpecialty required)
	if request.RoleID == 3 {
		if request.VetSpecialtyID == nil {
			return nil, errors.New("VetSpecialty is required for vet role")
		}

		if len(*request.VetSpecialtyID) <= 0 {
			return nil, errors.New("VetSpecialty is required for vet role")
		}

		// Validate all VetSpecialty IDs exist
		var validSpecialties []model.VetSpecialty
		if err := s.db.Where("id IN ?", *request.VetSpecialtyID).Find(&validSpecialties).Error; err != nil {
			return nil, err
		}

		if len(validSpecialties) != len(*request.VetSpecialtyID) {
			return nil, errors.New("one or more VetSpecialty IDs are invalid")
		}

		user.VetSpecialty = &validSpecialties
	}

	// Create User
	if err := s.db.Create(&user).Error; err != nil {
		return nil, err
	}

	jwtToken, expiry, err := helper.CreateJWT(user.ID)
	if err != nil {
		return nil, err
	}

	refreshToken := uuid.New().String()
	refreshTokenRecord := model.RefreshToken{
		UserID:    user.ID,
		Token:     refreshToken,
		ExpiresAt: time.Now().Add(14 * 24 * time.Hour), // 14 days expiry
	}
	if err := s.db.Create(&refreshTokenRecord).Error; err != nil {
		return nil, err
	}

	return &model.TokenResponse{
		UserID:       user.ID,
		AccessToken:  jwtToken,
		RefreshToken: refreshToken,
		ExpiryDate:   expiry.Unix(),
	}, nil
}

// DeleteUser removes a user from the database
func (s *UserServiceImpl) DeleteUser(id uint) error {
	var user model.User
	if err := s.db.First(&user, id).Error; err != nil {
		return err
	}

	if user.ImageUrl != nil {
		if err := os.Remove(helper.GetFilePath(*user.ImageUrl)); err != nil {
			return err
		}
	}

	if err := s.db.Unscoped().Delete(&model.User{}, id).Error; err != nil {
		return err
	}

	return nil
}

// UpdateUserProfile updates user details, including VetSpecialty assignments
func (s *UserServiceImpl) UpdateUserProfile(user *model.UpdateUserRequest) error {
	var existingUser model.User
	if err := s.db.Preload("VetSpecialty").First(&existingUser, user.ID).Error; err != nil {
		return err
	}

	// Update user fields
	existingUser.Name = user.Name
	existingUser.Email = user.Email
	existingUser.RoleID = user.RoleID
	if user.ImageUrl != "" {
		existingUser.ImageUrl = &user.ImageUrl
	}

	// Update VetSpecialty association if needed
	if user.RoleID == 3 && user.VetSpecialtyID != nil {
		var updatedSpecialties []model.VetSpecialty
		specialtyIDs := []uint{}

		specialtyIDs = append(specialtyIDs, *user.VetSpecialtyID...)

		if err := s.db.Where("id IN ?", specialtyIDs).Find(&updatedSpecialties).Error; err != nil {
			return err
		}

		// Ensure all requested VetSpecialties are valid
		if len(updatedSpecialties) != len(specialtyIDs) {
			return errors.New("one or more VetSpecialty IDs are invalid")
		}

		existingUser.VetSpecialty = &updatedSpecialties
	} else {
		existingUser.VetSpecialty = nil
	}

	// Save changes
	if err := s.db.Save(&existingUser).Error; err != nil {
		return err
	}

	return nil
}

// UpdateUserPassword changes the user's password
func (s *UserServiceImpl) UpdateUserPassword(id uint, newPassword string) error {
	var user model.User
	if err := s.db.First(&user, id).Error; err != nil {
		return err
	}

	hashedPassword, err := helper.HashPassword(newPassword)
	if err != nil {
		return err
	}

	user.Password = hashedPassword
	if err := s.db.Save(&user).Error; err != nil {
		return err
	}

	return nil
}
