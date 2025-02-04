package model

import "github.com/golang-jwt/jwt/v5"

type JWTClaim struct {
	jwt.RegisteredClaims
	UserID int64 `json:"userId,omitempty"`
}
