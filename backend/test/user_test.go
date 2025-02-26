package test

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"net/http/httptest"
	"os"
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
		{ID: 1, Name: "General Practice"},
		{ID: 2, Name: "Preventive Medicine"},
		{ID: 3, Name: "Emergency & Critical Care"},
	}

	emptyVetSpecialty := []model.VetSpecialty{}

	token1, _, _ := helper.CreateJWT(1)
	token3, _, _ := helper.CreateJWT(3)
	token10000, _, _ := helper.CreateJWT(10000)

	tests := []UserTestTable[int]{
		{
			Name:           "On get user, should return user info when user ID exists in DB",
			In:             1,
			Token:          token1,
			ExpectedStatus: 200,
			ExpectedOutput: model.UserDTO{
				ID:           1,
				Name:         "John Doe",
				Email:        "john@example.com",
				Role: model.Role{
					ID: 1,
					Name: "pet owner",
				},
				ImageUrl:     "test.com/image/test.jpeg",
				VetSpecialty: &emptyVetSpecialty,
			},
		},
		{
			Name:           "On login, should return error when user credential is correct",
			In:             4,
			Token:          token3,
			ExpectedStatus: 200,
			ExpectedOutput: model.UserDTO{
				ID:           4,
				Name:         "Dr. Vet",
				Email:        "vet@example.com",
				Role: model.Role{
					ID: 3,
					Name: "vet",
				},
				ImageUrl:     "test.com/image/test.jpeg",
				VetSpecialty: &vetSpecialty,
			},
		},
		{
			Name:           "On login, should return error when user ID does not exists in DB",
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

				if assert.NotEmpty(t, res.CreatedAt) {
					res.CreatedAt = ""
					assert.Equal(t, test.ExpectedOutput, res)
				}

			}

		})
	}
}

func TestGetVets(t *testing.T) {
	vetSpecialty := []model.VetSpecialty{
		{ID: 1, Name: "General Practice"},
		{ID: 2, Name: "Preventive Medicine"},
		{ID: 3, Name: "Emergency & Critical Care"},
	}

	token1, _, _ := helper.CreateJWT(1)

	tests := []UserTestTable[int]{
		{
			Name:           "On get vets, should return vets",
			In:             0,
			Token:          token1,
			ExpectedStatus: 200,
			ExpectedOutput: model.ListData[model.UserDTO]{
				Data: []model.UserDTO{
					{
						ID:           4,
						Name:         "Dr. Vet",
						Email:        "vet@example.com",
						Role: model.Role{
							ID: 3,
							Name: "vet",
						},
						ImageUrl:     "test.com/image/test.jpeg",
						VetSpecialty: &vetSpecialty,
					},
				},
			}, 	
		},
		{
			Name:           "On login, should return vet with chosen specialty id",
			In:             1,
			Token:          token1,
			ExpectedStatus: 200,
			ExpectedOutput: model.ListData[model.UserDTO]{
				Data: []model.UserDTO{
					{
						ID:           4,
						Name:         "Dr. Vet",
						Email:        "vet@example.com",
						Role: model.Role{
							ID: 3,
							Name: "vet",
						},
						ImageUrl:     "test.com/image/test.jpeg",
						VetSpecialty: &vetSpecialty,
					},
				},
			}, 	
		},
		{
			Name:           "On login, should return empty array if there is no doctor with chosen specialty id",
			In:             6,
			Token:          token1,
			ExpectedStatus: 200,
			ExpectedOutput: nil,
		},
	}
	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			db := setup.SetupTest(t)
			r := setup.Setup(db)

			w := httptest.NewRecorder()

			req, err := http.NewRequest("GET", fmt.Sprintf("/users/vets?specialty-id=%d", test.In), nil)
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))
			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code)

			if w.Code == 200 {
				var res model.ListData[model.UserDTO]
				resBody, _ := io.ReadAll(w.Body)

				if err := json.Unmarshal(resBody, &res); err != nil {
					t.Errorf("json Unmarshal err: %v", err)
				}

				if len(res.Data) > 0 {
					if assert.NotEmpty(t, res.Data[0].CreatedAt) {
						res.Data[0].CreatedAt = ""
						assert.Equal(t, test.ExpectedOutput, res)
					}
				}


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
			ExpectedStatus: 204,
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
			ExpectedStatus: 204,
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

			formFile, err := writer.CreateFormFile("image", "image/user_test.png")
			if err != nil {
				t.Fatalf("error creating form file: %v", err)
			}

			buf, err := os.Open("image/user_test.png")
			if err != nil {
				t.Fatalf("error opening file: %v", err)
			}
			defer buf.Close()

			_, err = io.Copy(formFile, buf)
			if err != nil {
				t.Fatalf("error sending image: %v", err)
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

			if w.Code == 204 {
				var user model.User

				db.First(&user, test.In.ID)
				assert.NotEqual(t, user.ImageUrl, "test.com/image/test.jpeg")
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
