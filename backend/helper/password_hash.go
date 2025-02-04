package helper

import (
	"crypto/rand"
	"crypto/subtle"
	"encoding/base64"
	"errors"
	"fmt"
	"strconv"
	"strings"

	"golang.org/x/crypto/argon2"
)

func HashPassword(password string) (string, error) {
	salt := make([]byte, 16)
	_, err := rand.Read(salt)
	if err != nil {
		return "", err
	}

	memory := uint32(64 * 1024)
	time := uint32(1)
	threads := uint8(1)
	keyLen := uint32(32)

	hash := argon2.IDKey([]byte(password), salt, time, memory, threads, keyLen)

	b64Salt := base64.RawStdEncoding.EncodeToString(salt)
	b64Hash := base64.RawStdEncoding.EncodeToString(hash)

	encodedHash := fmt.Sprintf("%d$%s$%s", argon2.Version, b64Salt, b64Hash)

	return encodedHash, nil
}

func VerifyHash(password string, hash string) (bool, error) {
	memory := uint32(64 * 1024)
	time := uint32(1)
	threads := uint8(1)
	keyLen := uint32(32)

	vals := strings.Split(hash, "$")
	if len(vals) != 3 {
		return false, errors.New("invalid hash")
	}

	version, err := strconv.Atoi(vals[0])
	if err != nil {
		return false, err
	}
	if version != argon2.Version {
		return false, errors.New("incompatible version")
	}

	salt, err := base64.RawStdEncoding.Strict().DecodeString(vals[1])
	if err != nil {
		return false, err
	}

	decodedHash, err := base64.RawStdEncoding.Strict().DecodeString(vals[2])
	if err != nil {
		return false, err
	}

	otherHash := argon2.IDKey([]byte(password), salt, time, memory, threads, keyLen)

	if subtle.ConstantTimeCompare(decodedHash, otherHash) == 1 {
		return true, nil
	}

	return false, nil
}
