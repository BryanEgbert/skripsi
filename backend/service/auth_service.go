package service

import (
	"errors"
	"log"
	"time"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

// AuthService interface
type AuthService interface {
	Login(email string, password string) (*model.TokenResponse, error)
	RefreshToken(refreshToken string) (*model.TokenResponse, error)
	Logout(userId uint) error
}

// AuthServiceImpl struct
type AuthServiceImpl struct {
	db *gorm.DB
}

// NewAuthService initializes AuthServiceImpl
func NewAuthService(db *gorm.DB) *AuthServiceImpl {
	return &AuthServiceImpl{db: db}
}

func (s *AuthServiceImpl) Logout(userId uint) error {
	if err := s.db.Unscoped().Where("user_id = ?", userId).Delete(&model.RefreshToken{}).Error; err != nil {
		log.Printf("Logout err: %v", err)
		return err
	}

	return nil
}

// Login function
func (s *AuthServiceImpl) Login(email string, password string) (*model.TokenResponse, error) {
	var user model.User
	if err := s.db.Where("email = ?", email).First(&user).Error; err != nil {
		return nil, errors.New("invalid email or password")
	}

	// Verify password
	valid, err := helper.VerifyHash(password, user.Password)
	if err != nil || !valid {
		return nil, errors.New("invalid email or password")
	}

	// Generate JWT token
	token, expiry, err := helper.CreateJWT(user.ID)
	if err != nil {
		return nil, err
	}

	// Generate Refresh Token
	refreshToken := uuid.New().String()

	// Store refresh token in DB
	refreshTokenRecord := model.RefreshToken{
		UserID: user.ID,

		Token:     refreshToken,
		ExpiresAt: time.Now().Add(14 * 24 * time.Hour), // 14 days expiration
	}
	if err := s.db.Create(&refreshTokenRecord).Error; err != nil {
		return nil, err
	}

	return &model.TokenResponse{
		UserID:       user.ID,
		RoleID:       user.RoleID,
		AccessToken:  token,
		RefreshToken: refreshToken,
		ExpiryDate:   expiry.Unix(), // Add expiry timestamp
	}, nil
}

// RefreshToken function
func (s *AuthServiceImpl) RefreshToken(refreshToken string) (*model.TokenResponse, error) {

	tokenRecord := model.RefreshToken{
		Token: refreshToken,
	}

	// Check if refresh token exists
	if err := s.db.First(&tokenRecord).Error; err != nil {
		return nil, errors.New("invalid refresh token")
	}

	if time.Now().After(tokenRecord.ExpiresAt) {
		s.db.Unscoped().Delete(&tokenRecord)
		return nil, errors.New("refresh token has expired")
	}

	var user model.User
	if err := s.db.First(&user, tokenRecord.UserID).Error; err != nil {
		return nil, errors.New("failed to fetch user")
	}

	// Delete the old refresh token
	s.db.Unscoped().Delete(&tokenRecord)

	// Generate new tokens
	newToken, expiry, err := helper.CreateJWT(tokenRecord.UserID)
	if err != nil {
		return nil, err
	}

	newRefreshToken := uuid.New().String()

	// Store new refresh token
	newTokenRecord := model.RefreshToken{
		UserID:    tokenRecord.UserID,
		Token:     newRefreshToken,
		ExpiresAt: time.Now().Add(14 * 24 * time.Hour),
	}
	if err := s.db.Create(&newTokenRecord).Error; err != nil {
		return nil, err
	}

	return &model.TokenResponse{
		UserID:       tokenRecord.UserID,
		RoleID:       user.RoleID,
		AccessToken:  newToken,
		RefreshToken: newRefreshToken,
		ExpiryDate:   expiry.Unix(), // Add expiry timestamp
	}, nil
}
