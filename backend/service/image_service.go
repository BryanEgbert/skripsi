package service

import (
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type ImageService interface {
	Upload(imageURL string) (string, error)
}

type ImageServiceImpl struct {
	db *gorm.DB
}

func NewImageService(db *gorm.DB) *ImageServiceImpl {
	return &ImageServiceImpl{db: db}
}

func (s *ImageServiceImpl) Upload(imageURL string) (string, error) {
	chatImage := model.ChatImage{
		ImageURL: imageURL,
	}

	if err := s.db.Create(&chatImage).Error; err != nil {
		return "", err
	}

	return imageURL, nil
}
