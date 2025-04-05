package middleware

import (
	"log"
	"os"
	"strings"
	"time"

	"github.com/BryanEgbert/skripsi/model"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

func JWTAuth() gin.HandlerFunc {
	return func(c *gin.Context) {
		if c.GetHeader("Authorization") == "" {
			c.Header("WWW-Authenticate", "Bearer")
			c.AbortWithStatus(401)
			return
		}

		tokenString := strings.Split(c.GetHeader("Authorization"), " ")[1]
		token, err := jwt.ParseWithClaims(tokenString, &model.JWTClaim{}, func(t *jwt.Token) (interface{}, error) {
			return []byte(os.Getenv("JWT_SECRET")), nil
		},
			jwt.WithValidMethods([]string{"HS256"}),
			jwt.WithAudience(os.Getenv("JWT_AUD")),
			jwt.WithExpirationRequired(),
			jwt.WithIssuer(os.Getenv("JWT_ISS")),
			jwt.WithSubject(os.Getenv("JWT_SUB")),
		)

		if err != nil {
			log.Printf("err: %v", err)
			c.AbortWithStatus(403)
			return
		}

		if !token.Valid {
			c.AbortWithStatus(403)
			return
		}

		claims, ok := token.Claims.(*model.JWTClaim)
		if !ok {
			c.AbortWithStatus(403)
		}

		if claims.ExpiresAt.Before(time.Now()) {
			c.AbortWithStatus(403)
		}

		if claims.NotBefore.After(time.Now()) {
			c.AbortWithStatus(403)
		}

		if claims.UserID == 0 {
			c.AbortWithStatus(403)
		}

		c.Set("userID", claims.UserID)
		c.Next()
	}
}

func RefreshJWTAuth() gin.HandlerFunc {
	return func(c *gin.Context) {
		if c.GetHeader("Authorization") == "" {
			c.Header("WWW-Authenticate", "Bearer")
			c.AbortWithStatus(401)
			return
		}

		tokenString := strings.Split(c.GetHeader("Authorization"), " ")[1]
		token, err := jwt.ParseWithClaims(tokenString, &model.JWTClaim{}, func(t *jwt.Token) (interface{}, error) {
			return []byte(os.Getenv("JWT_SECRET")), nil
		},
			jwt.WithValidMethods([]string{"HS256"}),
			jwt.WithAudience(os.Getenv("JWT_AUD")),
			jwt.WithExpirationRequired(),
			jwt.WithIssuer(os.Getenv("JWT_ISS")),
			jwt.WithSubject(os.Getenv("JWT_SUB")),
		)

		if err != nil {
			log.Printf("err: %v", err)
			c.AbortWithStatus(403)
			return
		}

		if !token.Valid {
			c.AbortWithStatus(403)
			return
		}

		claims, ok := token.Claims.(*model.JWTClaim)
		if !ok {
			c.AbortWithStatus(403)
		}

		if claims.NotBefore.After(time.Now()) {
			c.AbortWithStatus(403)
		}

		if claims.UserID == 0 {
			c.AbortWithStatus(403)
		}

		c.Set("userID", claims.UserID)
		c.Next()
	}
}
