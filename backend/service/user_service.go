package service

import (
	"errors"
	"time"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

// UserService interface defining the required methods
type UserService interface {
	GetUser(id int64) (*model.UserDTO, error)
	CreateUser(user model.CreateUserRequest) (*model.TokenResponse, error)
	DeleteUser(id int64) error
	UpdateUserProfile(user *model.UpdateUserDTO) (*model.UserDTO, error)
	UpdateUserPassword(id uint, newPassword string) error
}

// UserServiceImpl struct implementing UserService
type UserServiceImpl struct {
	db *gorm.DB
}

// NewUserService initializes UserServiceImpl with a GORM database connection
func NewUserService(db *gorm.DB) *UserServiceImpl {
	return &UserServiceImpl{db: db}
}

// GetUser retrieves a user by ID and returns a UserDTO
func (s *UserServiceImpl) GetUser(id int64) (*model.UserDTO, error) {
	var user model.User
	if err := s.db.Preload("VetSpecialty").First(&user, id).Error; err != nil {
		return nil, err
	}

	userDTO := &model.UserDTO{
		ID:           user.ID,
		Name:         user.Name,
		Email:        user.Email,
		RoleID:       user.RoleID,
		CreatedAt:    user.CreatedAt,
		VetSpecialty: user.VetSpecialty,
	}

	return userDTO, nil
}

// CreateUser creates a new user with proper VetSpecialty assignments
func (s *UserServiceImpl) CreateUser(request model.CreateUserRequest) (*model.TokenResponse, error) {
	hashedPassword, err := helper.HashPassword(request.Password)
	if err != nil {
		return nil, err
	}

	user := model.User{
		Name:     request.Name,
		Email:    request.Email,
		Password: hashedPassword,
		RoleID:   request.RoleID,
	}

	// Validate Role exists
	var roleExists bool
	if err := s.db.Model(&model.Role{}).Select("count(*) > 0").
		Where("id = ?", request.RoleID).
		Find(&roleExists).Error; err != nil {
		return nil, err
	}
	if !roleExists {
		return nil, errors.New("Invalid role ID")
	}

	// Vet role validation (VetSpecialty required)
	if request.RoleID == 3 {
		if request.VetSpecialtyID == nil || len(*request.VetSpecialtyID) == 0 {
			return nil, errors.New("VetSpecialty is required for vet role")
		}

		// Validate all VetSpecialty IDs exist
		var validSpecialties []model.VetSpecialty
		if err := s.db.Where("id IN ?", *request.VetSpecialtyID).Find(&validSpecialties).Error; err != nil {
			return nil, err
		}

		if len(validSpecialties) != len(*request.VetSpecialtyID) {
			return nil, errors.New("One or more VetSpecialty IDs are invalid")
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
		AccessToken:  jwtToken,
		RefreshToken: refreshToken,
		ExpiryDate:   expiry.Unix(),
	}, nil
}

// DeleteUser removes a user from the database
func (s *UserServiceImpl) DeleteUser(id int64) error {
	if err := s.db.Delete(&model.User{}, id).Error; err != nil {
		return err
	}
	return nil
}

// UpdateUserProfile updates user details, including VetSpecialty assignments
func (s *UserServiceImpl) UpdateUserProfile(user *model.UpdateUserDTO) (*model.UserDTO, error) {
	var existingUser model.User
	if err := s.db.Preload("VetSpecialty").First(&existingUser, user.ID).Error; err != nil {
		return nil, err
	}

	// Update user fields
	existingUser.Name = user.Name
	existingUser.Email = user.Email
	existingUser.RoleID = user.RoleID

	// Update VetSpecialty association if needed
	if user.RoleID == 3 && user.VetSpecialtyID != nil {
		var updatedSpecialties []model.VetSpecialty
		specialtyIDs := []uint{}

		for _, specialty := range *user.VetSpecialtyID {
			specialtyIDs = append(specialtyIDs, specialty)
		}

		if err := s.db.Where("id IN ?", specialtyIDs).Find(&updatedSpecialties).Error; err != nil {
			return nil, err
		}

		// Ensure all requested VetSpecialties are valid
		if len(updatedSpecialties) != len(specialtyIDs) {
			return nil, errors.New("One or more VetSpecialty IDs are invalid")
		}

		existingUser.VetSpecialty = &updatedSpecialties
	} else {
		existingUser.VetSpecialty = nil
	}

	// Save changes
	if err := s.db.Save(&existingUser).Error; err != nil {
		return nil, err
	}

	return &model.UserDTO{
		ID:           existingUser.ID,
		Name:         existingUser.Name,
		Email:        existingUser.Email,
		RoleID:       existingUser.RoleID,
		CreatedAt:    existingUser.CreatedAt,
		VetSpecialty: existingUser.VetSpecialty,
	}, nil
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
