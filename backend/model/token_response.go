package model

type TokenResponse struct {
	UserID       uint   `json:"userId"`
	RoleID       uint   `json:"roleId"`
	AccessToken  string `json:"accessToken"`
	RefreshToken string `json:"refreshToken"`
	ExpiryDate   int64  `json:"exp"`
}
