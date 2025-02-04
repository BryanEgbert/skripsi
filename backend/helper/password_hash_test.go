//go:build unit || !int
// +build unit !int

package helper_test

import (
	"testing"

	"github.com/BryanEgbert/skripsi/helper"
)

func TestHashPassword(t *testing.T) {
	t.Run("When hash and verify the same password, should return true when verifying", func(t *testing.T) {
		password := "testpassword123"

		hash, err := helper.HashPassword(password)
		if err != nil {
			t.Errorf("HashPassword err: %v", err)
		}

		t.Logf("hash: %s", hash)

		isMatched, err := helper.VerifyHash(password, hash)
		if err != nil {
			t.Errorf("VerifyHash err: %v", err)
		}

		if !isMatched {
			t.Errorf("password does does not match")
		}
	})

	t.Run("When hash and verify different passwords, should return false when verifying", func(t *testing.T) {
		password := "testpassword123"

		hash, err := helper.HashPassword(password)
		if err != nil {
			t.Errorf("HashPassword err: %v", err)
		}

		isMatched, err := helper.VerifyHash("wrong password", hash)
		if err != nil {
			t.Errorf("VerifyHash err: %v", err)
		}

		if isMatched {
			t.Errorf("password should not match")
		}
	})
}
