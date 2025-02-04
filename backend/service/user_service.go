package service

import (
	"errors"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

// UserService interface defining the required methods
type UserService interface {
	GetUser(id int64) (*model.UserDTO, error)
	CreateUser(user model.User) (*model.UserDTO, error)
	DeleteUser(id int64) error
	UpdateUserProfile(user *model.UserDTO) (*model.UserDTO, error)
	UpdateUserPassword(id int64, newPassword string) error
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
	if err := s.db.First(&user, id).Error; err != nil {
		return nil, err
	}

	userDTO := &model.UserDTO{
		ID:        user.ID,
		Name:      user.Name,
		Email:     user.Email,
		RoleID:    user.RoleID,
		CreatedAt: user.CreatedAt,
	}

	return userDTO, nil
}

func (s *UserServiceImpl) CreateUser(user model.User) (*model.UserDTO, error) {
	hashedPassword, err := helper.HashPassword(user.Password)
	if err != nil {
		return nil, err
	}
	user.Password = hashedPassword

	if user.RoleID == 2 {
		if user.VetSpecialtyID == nil {
			return nil, errors.New("VetSpecialtyID is required for vet role")
		}
	} else {
		user.VetSpecialtyID = nil
	}

	if err := s.db.Create(&user).Error; err != nil {
		return nil, err
	}

	userDTO := &model.UserDTO{
		ID:        user.ID,
		Name:      user.Name,
		Email:     user.Email,
		RoleID:    user.RoleID,
		CreatedAt: user.CreatedAt,
	}

	return userDTO, nil
}

func (s *UserServiceImpl) DeleteUser(id int64) error {
	if err := s.db.Delete(&model.User{}, id).Error; err != nil {
		return err
	}
	return nil
}

func (s *UserServiceImpl) UpdateUserProfile(user *model.UserDTO) (*model.UserDTO, error) {
	var existingUser model.User
	if err := s.db.First(&existingUser, user.ID).Error; err != nil {
		return nil, err
	}

	existingUser.Name = user.Name
	existingUser.Email = user.Email
	existingUser.RoleID = user.RoleID

	if err := s.db.Save(&existingUser).Error; err != nil {
		return nil, err
	}

	return user, nil
}

func (s *UserServiceImpl) UpdateUserPassword(id int64, newPassword string) error {
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
