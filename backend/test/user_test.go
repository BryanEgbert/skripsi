package test

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"net/http/httptest"
	"strconv"
	"strings"
	"testing"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/setup"
	"github.com/stretchr/testify/assert"
)

type UserTestTable[T any] struct {
	Name           string
	In             T
	Token          string
	ExpectedStatus int
	ExpectedOutput any
}

func TestGetUser(t *testing.T) {
	vetSpecialty := []model.VetSpecialty{
		{Name: "General Practice"},
		{Name: "Preventive Medicine"},
		{Name: "Emergency & Critical Care"},
	}

	token1, _, _ := helper.CreateJWT(1)
	token3, _, _ := helper.CreateJWT(3)
	token10000, _, _ := helper.CreateJWT(10000)

	tests := []UserTestTable[int]{
		{
			Name:           "On login, should return tokens when user credential is correct",
			In:             1,
			Token:          token1,
			ExpectedStatus: 200,
			ExpectedOutput: model.UserDTO{
				ID:       1,
				Name:     "John Doe",
				Email:    "john@example.com",
				RoleID:   1,
				ImageUrl: "test.jpg",
			},
		},
		{
			Name:           "On login, should return error when user credential is correct",
			In:             3,
			Token:          token3,
			ExpectedStatus: 200,
			ExpectedOutput: model.UserDTO{
				ID:           3,
				Name:         "Dr. Vet",
				Email:        "vet@example.com",
				RoleID:       3,
				ImageUrl:     "test.jpg",
				VetSpecialty: &vetSpecialty,
			},
		},
		{
			Name:           "On login, should return error when user credential is correct",
			In:             10000,
			Token:          token10000,
			ExpectedStatus: 404,
			ExpectedOutput: nil,
		},
	}
	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			db := setup.SetupTest(t)
			r := setup.Setup(db)

			w := httptest.NewRecorder()

			req, err := http.NewRequest("GET", fmt.Sprintf("/users/%d", test.In), nil)
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))
			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code)

			if w.Code == 200 {
				var res model.UserDTO
				resBody, _ := io.ReadAll(w.Body)

				if err := json.Unmarshal(resBody, &res); err != nil {
					t.Errorf("json Unmarshal err: %v", err)
				}

				assert.Equal(t, test.ExpectedOutput, res)
			}

		})
	}
}

func TestDeleteUser(t *testing.T) {
	token4, _, _ := helper.CreateJWT(4)
	token10000, _, _ := helper.CreateJWT(10000)

	tests := []UserTestTable[any]{
		{
			Name:           "On delete user, should return 204 when user ID exists in DB",
			Token:          token4,
			ExpectedStatus: 204,
		},
		{
			Name:           "On delete user, should return 404 when user ID doesn't exists in DB",
			Token:          token10000,
			ExpectedStatus: 404,
		},
	}
	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			db := setup.SetupTest(t)
			r := setup.Setup(db)

			w := httptest.NewRecorder()

			req, err := http.NewRequest("DELETE", "/users", nil)
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))
			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code, w.Body.String())
		})
	}
}

func TestUpdateUser(t *testing.T) {
	token1, _, _ := helper.CreateJWT(1)
	token4, _, _ := helper.CreateJWT(4)
	token10000, _, _ := helper.CreateJWT(10000)

	updateVetSpecialties := []uint{2, 4, 5}
	emptyVetSpecialties := []uint{}

	tests := []UserTestTable[model.UpdateUserRequest]{
		{
			Name: "On update user, should return 200 and updated user",
			In: model.UpdateUserRequest{
				ID:     1,
				Name:   "update name",
				Email:  "update@example.com",
				RoleID: 1,
			},
			Token:          token1,
			ExpectedStatus: 200,
			ExpectedOutput: model.UpdateUserDTO{
				ID:             1,
				Name:           "update name",
				Email:          "update@example.com",
				VetSpecialtyID: &emptyVetSpecialties,
				RoleID:         1,
			},
		},
		{
			Name: "On update user, should return 200 and updated user and vet specialties",
			In: model.UpdateUserRequest{
				ID:             4,
				Name:           "update vet name",
				Email:          "vetupdate@example.com",
				RoleID:         3,
				VetSpecialtyID: &updateVetSpecialties,
			},
			Token:          token4,
			ExpectedStatus: 200,
			ExpectedOutput: model.UpdateUserDTO{
				ID:             4,
				Name:           "update vet name",
				Email:          "vetupdate@example.com",
				RoleID:         3,
				VetSpecialtyID: &updateVetSpecialties,
			},
		},
		{
			Name:  "On update user, should return 404 when user ID doesn't exists in DB",
			Token: token10000,
			In: model.UpdateUserRequest{
				ID:     10000,
				Name:   "dummy name",
				Email:  "dummy@example.com",
				RoleID: 1,
			},
			ExpectedStatus: 404,
		},
	}
	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			db := setup.SetupTest(t)
			r := setup.Setup(db)

			w := httptest.NewRecorder()

			body := &bytes.Buffer{}
			writer := multipart.NewWriter(body)

			_ = writer.WriteField("name", test.In.Name)
			_ = writer.WriteField("email", test.In.Email)
			_ = writer.WriteField("roleId", strconv.Itoa(int(test.In.RoleID)))
			if test.In.VetSpecialtyID != nil {
				for _, vetSpecialtyID := range *test.In.VetSpecialtyID {
					_ = writer.WriteField("vetSpecialtyId[]", strconv.Itoa(int(vetSpecialtyID)))
				}
			}

			writer.Close()

			req, err := http.NewRequest("PUT", "/users", body)
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			req.Header.Set("Content-Type", writer.FormDataContentType())
			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))

			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code, w.Body.String())

			if w.Code == 200 {
				var res model.UpdateUserDTO
				resBody, _ := io.ReadAll(w.Body)

				if err := json.Unmarshal(resBody, &res); err != nil {
					t.Errorf("json Unmarshal err: %v", err)
				}

				assert.Equal(t, test.ExpectedOutput, res)
			}
		})
	}
}

func TestUpdatePassword(t *testing.T) {
	token4, _, _ := helper.CreateJWT(4)
	token10000, _, _ := helper.CreateJWT(10000)

	tests := []UserTestTable[model.UpdatePasswordRequest]{
		{
			Name:  "On update password, should return 204 when user ID exists in DB and newPassword is not empty",
			Token: token4,
			In: model.UpdatePasswordRequest{
				NewPassword: "newPassword",
			},
			ExpectedStatus: 204,
		},
		{
			Name:  "On update password, should return 404 when newPassword is empty",
			Token: token4,
			In: model.UpdatePasswordRequest{
				NewPassword: "",
			},
			ExpectedStatus: 400,
		},
		{
			Name:  "On update password, should return 404 when user ID doesn't exists in DB",
			Token: token10000,
			In: model.UpdatePasswordRequest{
				NewPassword: "newPassword",
			},
			ExpectedStatus: 404,
		},
	}
	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			db := setup.SetupTest(t)
			r := setup.Setup(db)

			w := httptest.NewRecorder()

			reqJson, err := json.Marshal(test.In)
			if err != nil {
				t.Errorf("json Marshal err: %v", err)
			}

			req, err := http.NewRequest("PATCH", "/users/password", strings.NewReader(string(reqJson)))
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))
			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code, w.Body.String())
		})
	}
}
