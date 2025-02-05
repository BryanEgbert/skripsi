package model

type CreateUserRequest struct {
	Name           string  `json:"name"`
	Email          string  `json:"email"`
	Password       string  `json:"password"`
	RoleID         uint    `json:"roleId"`
	VetSpecialtyID *[]uint `json:"vetSpecialtyId"`
}

type UpdateUserRequest struct {
	Name           string  `json:"name"`
	Email          string  `json:"email"`
	RoleID         uint    `json:"roleId"`
	VetSpecialtyID *[]uint `json:"vetSpecialtyId"`
}
