package test

import (
	"bytes"
	"encoding/json"
	"io"
	"mime/multipart"
	"net/http"
	"net/http/httptest"
	"strconv"
	"strings"
	"testing"

	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/setup"
	"github.com/stretchr/testify/assert"
)

type AuthTableTest[T any, O any] struct {
	Name           string
	In             T
	ExpectedStatus int
}

func TestLogin(t *testing.T) {
	tests := []AuthTableTest[model.LoginRequest, model.TokenResponse]{
		{
			Name: "On login, should return tokens when user credential is correct",
			In: model.LoginRequest{
				Email:    "john@example.com",
				Password: "test",
			},
			ExpectedStatus: 200,
		},
		{
			Name: "On login, should return error when user password is not correct",
			In: model.LoginRequest{
				Email:    "john@example.com",
				Password: "wrong_password",
			},
			ExpectedStatus: 401,
		},
		{
			Name: "On login, should return error when user email is correct",
			In: model.LoginRequest{
				Email:    "wrong@mail.com",
				Password: "test",
			},
			ExpectedStatus: 401,
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

			req, err := http.NewRequest("POST", "/login", strings.NewReader(string(reqJson)))
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code)

			if w.Code == 200 {
				var res model.TokenResponse
				resBody, _ := io.ReadAll(w.Body)

				if err := json.Unmarshal(resBody, &res); err != nil {
					t.Errorf("json Unmarshal err: %v", err)
				}

				assert.NotEqual(t, res.AccessToken, "")
				assert.NotEqual(t, res.RefreshToken, "")

				t.Logf("\naccessToken: %s\nrefreshToken: %s\nexp: %d", res.AccessToken, res.RefreshToken, res.ExpiryDate)
			}

		})
	}
}

func TestRegister(t *testing.T) {
	tests := []AuthTableTest[model.CreateUserRequest, model.TokenResponse]{
		{
			Name: "On register, should return tokens when user credential is correct",
			In: model.CreateUserRequest{
				Email:    "newtest@mail.com",
				Password: "test",
				Name:     "new_user1",
				RoleID:   1,
			},
			ExpectedStatus: 201,
		},
		{
			Name: "On register, should return error when email is the same",
			In: model.CreateUserRequest{
				Email:    "john@example.com",
				Password: "test",
				Name:     "new_user2",
				RoleID:   1,
			},
			ExpectedStatus: 409,
		},
		{
			Name: "On register, should return error when name is the same",
			In: model.CreateUserRequest{
				Email:    "newtest2@mail.com",
				Password: "test",
				Name:     "John Doe",
				RoleID:   1,
			},
			ExpectedStatus: 409,
		},
		{
			Name: "On register, should return error when vet specialties are empty when role ID is 3",
			In: model.CreateUserRequest{
				Email:    "newtest3@mail.com",
				Password: "test",
				Name:     "new_user3",
				RoleID:   3,
			},
			ExpectedStatus: 400,
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
			_ = writer.WriteField("password", test.In.Password)
			_ = writer.WriteField("roleId", strconv.Itoa(int(test.In.RoleID)))

			writer.Close()

			req, err := http.NewRequest("POST", "/users", body)
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}

			req.Header.Set("Content-Type", writer.FormDataContentType())
			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code)

			if w.Code == 200 {
				var res model.TokenResponse
				resBody, _ := io.ReadAll(w.Body)

				if err := json.Unmarshal(resBody, &res); err != nil {
					t.Errorf("json Unmarshal err: %v", err)
				}

				assert.NotEqual(t, res.AccessToken, "")
				assert.NotEqual(t, res.RefreshToken, "")

				t.Logf("\naccessToken: %s\nrefreshToken: %s\nexp: %d", res.AccessToken, res.RefreshToken, res.ExpiryDate)
			}
		})
	}
}
