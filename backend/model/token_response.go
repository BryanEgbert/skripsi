package model

type TokenResponse struct {
	UserID uint `json:"userId"`
	AccessToken  string `json:"accessToken"`
	RefreshToken string `json:"refreshToken"`
	ExpiryDate   int64  `json:"exp"`
}
