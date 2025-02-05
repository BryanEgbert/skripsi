package helper

import (
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

func CreateJWT(userId uint) (string, time.Time, error) {
	exp := time.Now().Add(60 * time.Minute)
	claims := jwt.MapClaims{}
	claims["exp"] = jwt.NewNumericDate(exp)
	claims["nbf"] = jwt.NewNumericDate(time.Now())
	claims["iat"] = jwt.NewNumericDate(time.Now())
	claims["aud"] = os.Getenv("JWT_AUD")
	claims["jti"] = uuid.NewString()
	claims["sub"] = os.Getenv("JWT_SUB")
	claims["iss"] = os.Getenv("JWT_ISS")
	claims["userId"] = userId

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	tokenString, err := token.SignedString([]byte(os.Getenv("JWT_SECRET")))
	if err != nil {
		return "", time.Time{}, err
	}

	return tokenString, exp, nil
}

// For test only, use CreateJWT function instead for production code
func CreateJWTCustom(userId int64, alg jwt.SigningMethod, nbf time.Time, exp time.Time, aud string, sub string, iss string) (string, error) {
	token := jwt.New(alg)

	claims := token.Claims.(jwt.MapClaims)
	claims["exp"] = jwt.NewNumericDate(exp)
	claims["nbf"] = jwt.NewNumericDate(nbf)
	claims["iat"] = jwt.NewNumericDate(time.Now())
	claims["aud"] = aud
	claims["jti"] = uuid.NewString()
	claims["sub"] = sub
	claims["iss"] = iss
	claims["userId"] = userId

	tokenString, err := token.SignedString([]byte(os.Getenv("JWT_SECRET")))
	if err != nil {
		return "", err
	}

	return tokenString, nil
}

// For test only, use CreateJWT function instead for production code
func CreateJWTCustomNoUserId(alg jwt.SigningMethod, nbf time.Time, exp time.Time, aud string, sub string, iss string) (string, error) {
	token := jwt.New(alg)

	claims := token.Claims.(jwt.MapClaims)
	claims["exp"] = jwt.NewNumericDate(exp)
	claims["nbf"] = jwt.NewNumericDate(nbf)
	claims["iat"] = jwt.NewNumericDate(time.Now())
	claims["aud"] = aud
	claims["jti"] = uuid.NewString()
	claims["sub"] = sub
	claims["iss"] = iss

	tokenString, err := token.SignedString([]byte(os.Getenv("JWT_SECRET")))
	if err != nil {
		return "", err
	}

	return tokenString, nil
}
