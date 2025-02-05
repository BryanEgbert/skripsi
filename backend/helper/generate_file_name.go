package helper

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"time"
)

func GenerateFileName(userID uint, fileExtension string) string {
	timestamp := time.Now().UnixNano()
	uniqueStr := fmt.Sprintf("%d-%d", userID, timestamp)

	hash := sha256.Sum256([]byte(uniqueStr))
	fileName := hex.EncodeToString(hash[:]) + fileExtension

	return fileName
}
