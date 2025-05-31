package model

import (
	"mime/multipart"

	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	Name        string  `gorm:"not null"`
	Email       string  `gorm:"unique;not null"`
	Password    string  `gorm:"not null"`
	ImageUrl    *string `gorm:"default:null"`
	RoleID      uint    `gorm:"not null"`
	DeviceToken *string

	Role           Role            `gorm:"foreignKey:RoleID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
	VetSpecialty   *[]VetSpecialty `gorm:"default:null;many2many:user_vet_specialties;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	PetDaycare     *PetDaycare     `gorm:"foreignKey:OwnerID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-One relationship
	Pets           []Pet           `gorm:"foreignKey:OwnerID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many relationship
	Reviews        []Reviews       `gorm:"foreignKey:UserID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	SavedAddresses []SavedAddress  `gorm:"foreignKey:UserID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

type UserDTO struct {
	ID           uint           `json:"id"`
	Name         string         `json:"name"`
	Email        string         `json:"email"`
	ImageUrl     string         `json:"imageUrl"`
	Role         Role           `json:"role"`
	VetSpecialty []VetSpecialty `json:"vetSpecialties"`
	CreatedAt    string         `json:"createdAt"`
}

type UpdateUserDTO struct {
	ID             uint    `json:"id"`
	Name           string  `json:"name"`
	Email          string  `json:"email"`
	ImageUrl       string  `json:"imageUrl"`
	RoleID         uint    `json:"roleId"`
	VetSpecialtyID *[]uint `json:"vetSpecialtyId[]"`
}

type CreateUserRequest struct {
	Name           string                `form:"displayName" binding:"required"`
	Email          string                `form:"email" binding:"required,email"`
	Password       string                `form:"password" binding:"required"`
	RoleID         uint                  `form:"roleId" binding:"required"`
	VetSpecialtyID *[]uint               `form:"vetSpecialtyId[]"`
	UserImage      *multipart.FileHeader `form:"userProfilePicture"`
	DeviceToken    *string               `form:"deviceToken"`
	UserImageUrl   string
}

type CreatePetOwnerRequest struct {
	CreateUserRequest
	PetRequest
	VaccineRecordRequest
}

type CreatePetDaycareProviderRequest struct {
	CreateUserRequest
	CreatePetDaycareRequest
}

type UpdateUserRequest struct {
	ID             uint
	Name           string                `form:"name"`
	Email          string                `form:"email" binding:"email"`
	RoleID         uint                  `form:"roleId"`
	VetSpecialtyID *[]uint               `form:"vetSpecialtyId[]"`
	Image          *multipart.FileHeader `form:"userProfilePicture"`
	ImageUrl       string
}

type UpdatePasswordRequest struct {
	NewPassword string `json:"new_password" binding:"required"`
}
