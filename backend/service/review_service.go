package service

import (
	"errors"

	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type ReviewService interface {
	GetReviews(petDaycareId uint, startID uint, pageSize int) (*[]model.ReviewsDTO, error)
	CreateReview(petDaycareId uint, userId uint, req model.CreateReviewRequest) error
	DeleteReview(petDaycareId uint, userId uint) error
}

type ReviewServiceImpl struct {
	db *gorm.DB
}

func NewReviewService(db *gorm.DB) *ReviewServiceImpl {
	return &ReviewServiceImpl{db: db}
}

func (r *ReviewServiceImpl) GetReviews(petDaycareId uint, startID uint, pageSize int) (*[]model.ReviewsDTO, error) {
	var reviews []model.ReviewsDTO
	if err := r.db.
		Preload("User").
		Where("daycare_id = ? AND id > ?", petDaycareId, startID).
		Order("id ASC").
		Limit(pageSize).
		Find(&reviews).Error; err != nil {
		return nil, err
	}

	return &reviews, nil
}

func (r *ReviewServiceImpl) CreateReview(petDaycareId uint, userId uint, req model.CreateReviewRequest) error {
	review := model.Reviews{
		DaycareID:   petDaycareId,
		UserID:      userId,
		Name:        req.Title, // Title corresponds to Name
		Rate:        req.Rating,
		Description: req.Description,
	}

	if err := r.db.Create(&review).Error; err != nil {
		return err
	}
	return nil
}

func (r *ReviewServiceImpl) DeleteReview(petDaycareId uint, userId uint) error {
	var review model.Reviews

	// Find review by user and daycare
	err := r.db.Where("daycare_id = ? AND user_id = ?", petDaycareId, userId).First(&review).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return errors.New("review not found")
	}

	// Delete review
	if err := r.db.Delete(&review).Error; err != nil {
		return err
	}
	return nil
}
