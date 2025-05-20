package model

import "mime/multipart"

type ChatImage struct {
	ID       uint   `gorm:"primaryKey"`
	ImageURL string `gorm:"not null"`
}

type ChatImageRequest struct {
	Image *multipart.FileHeader `form:"image" binding:"required"`
}
