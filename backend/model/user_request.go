package model

import "mime/multipart"

type CreateUserRequest struct {
	Name           string                `form:"name" binding:"required"`
	Email          string                `form:"email" binding:"required,email"`
	Password       string                `form:"password" binding:"required"`
	RoleID         uint                  `form:"roleId" binding:"required"`
	VetSpecialtyID *[]uint               `form:"vetSpecialtyId"`
	Image          *multipart.FileHeader `form:"image"`
	ImageUrl       string
}

type UpdateUserRequest struct {
	ID             uint
	Name           string                `form:"name"`
	Email          string                `form:"email" binding:"email"`
	RoleID         uint                  `form:"roleId"`
	VetSpecialtyID *[]uint               `form:"vetSpecialtyId[]"`
	Image          *multipart.FileHeader `form:"image"`
	ImageUrl       string
}

type UpdatePasswordRequest struct {
	NewPassword string `json:"new_password" binding:"required"`
}
