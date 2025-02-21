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
	"testing"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/setup"
	"github.com/stretchr/testify/assert"
)

type PetTestTable[T any] struct {
	Name           string
	In             T
	ID             int
	Token          string
	ExpectedStatus int
	ExpectedOutput any
}

func TestGetPet(t *testing.T) {
	token1, _, _ := helper.CreateJWT(1)

	tests := []UserTestTable[int]{
		{
			Name:           "On get pet, should return petDTO when pet ID exists in DB",
			In:             1,
			Token:          token1,
			ExpectedStatus: 200,
			ExpectedOutput: model.PetDTO{
				ID:       1,
				Name:     "Buddy",
				ImageUrl: "test.com/image/dog.jpeg",
				Status:   "idle",
				Species: model.Species{
					ID:   1,
					Name: "dogs",
				},
				SizeCategory: model.SizeCategory{
					ID:        1,
					Name:      "small",
					MinWeight: 0,
					MaxWeight: 10,
				},
				Owner: model.UserDTO{
					ID:       1,
					Name:     "John Doe",
					Email:    "john@example.com",
					ImageUrl: "test.com/image/test.jpeg",
					Role:   "pet owner",
				},
			},
		},
		{
			Name:           "On get pet, should return error when pet ID doesn't exists in DB",
			In:             3,
			Token:          token1,
			ExpectedStatus: 404,
		},
	}
	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			db := setup.SetupTest(t)
			r := setup.Setup(db)

			w := httptest.NewRecorder()

			req, err := http.NewRequest("GET", fmt.Sprintf("/pets/%d", test.In), nil)
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))
			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code)

			if w.Code == 200 {
				var res model.PetDTO
				resBody, _ := io.ReadAll(w.Body)

				if err := json.Unmarshal(resBody, &res); err != nil {
					t.Errorf("json Unmarshal err: %v", err)
				}

				if assert.NotEmpty(t, res.Owner.CreatedAt) {
					res.Owner.CreatedAt = ""
					assert.Equal(t, test.ExpectedOutput, res)
				}

			}

		})
	}
}

func TestGetPets(t *testing.T) {
	token1, _, _ := helper.CreateJWT(1)

	tests := []PetTestTable[int]{
		{
			Name:           "On get pet, should return petDTO when pet ID exists in DB",
			In:             1,
			Token:          token1,
			ExpectedStatus: 200,
			ExpectedOutput: []model.PetDTO{
				{
					ID:       1,
					Name:     "Buddy",
					ImageUrl: "test.com/image/dog.jpeg",
					Status:   "idle",
					Species: model.Species{
						ID:   1,
						Name: "dogs",
					},
					SizeCategory: model.SizeCategory{
						ID:        1,
						Name:      "small",
						MinWeight: 0,
						MaxWeight: 10,
					},
					Owner: model.UserDTO{
						ID:       1,
						Name:     "John Doe",
						Email:    "john@example.com",
						ImageUrl: "test.com/image/test.jpeg",
						Role:   "pet owner",
					},
				},
				{
					ID:       2,
					Name:     "Buddy2",
					ImageUrl: "test.com/image/dog.jpeg",
					Status:   "idle",
					Species: model.Species{
						ID:   1,
						Name: "dogs",
					},
					SizeCategory: model.SizeCategory{
						ID:        2,
						Name:      "medium",
						MinWeight: 11,
						MaxWeight: 26,
					},
					Owner: model.UserDTO{
						ID:       1,
						Name:     "John Doe",
						Email:    "john@example.com",
						ImageUrl: "test.com/image/test.jpeg",
						Role:   "pet owner",
					},
				},
			},
		},
	}
	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			db := setup.SetupTest(t)
			r := setup.Setup(db)

			w := httptest.NewRecorder()

			req, err := http.NewRequest("GET", "/pets", nil)
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))
			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code, w.Body.String())

			if w.Code == 200 {
				var res []model.PetDTO
				resBody, _ := io.ReadAll(w.Body)

				if err := json.Unmarshal(resBody, &res); err != nil {
					t.Errorf("json Unmarshal err: %v", err)
				}

				for i, _ := range res {
					if assert.NotEmpty(t, res[i].Owner.CreatedAt) {
						res[i].Owner.CreatedAt = ""
					}
				}
				assert.Equal(t, test.ExpectedOutput, res)
			}

		})
	}
}

func TestCreatePet(t *testing.T) {
	token1, _, _ := helper.CreateJWT(1)

	tests := []PetTestTable[model.PetRequest]{
		{
			Name:  "On create pet, should return 201 on success",
			Token: token1,
			In: model.PetRequest{
				Name:           "new_pet",
				SpeciesID:      2,
				SizeCategoryID: 2,
			},
			ExpectedStatus: 201,
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
			_ = writer.WriteField("status", test.In.Status)
			_ = writer.WriteField("speciesId", strconv.Itoa(int(test.In.SpeciesID)))
			_ = writer.WriteField("sizeCategoryId", strconv.Itoa(int(test.In.SizeCategoryID)))

			formFile, err := writer.CreateFormFile("image", "image/test.jpeg")
			if err != nil {
				t.Fatalf("error creating form file: %v", err)
			}

			buf, err := os.Open("image/test.jpeg")
			if err != nil {
				t.Fatalf("error opening file: %v", err)
			}
			defer buf.Close()

			_, err = io.Copy(formFile, buf)
			if err != nil {
				t.Fatalf("error sending image: %v", err)
			}

			writer.Close()

			req, err := http.NewRequest("POST", "/pets", body)
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			req.Header.Set("Content-Type", writer.FormDataContentType())
			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))

			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code, w.Body.String())
		})
	}
}

func TestUpdatePet(t *testing.T) {
	token1, _, _ := helper.CreateJWT(1)

	tests := []PetTestTable[model.PetRequest]{
		{
			Name: "On update pet, should return 204 if pet update successfully",
			ID:   1,
			In: model.PetRequest{
				Name:           "update_name",
				Status:         "sleeping",
				SpeciesID:      2,
				SizeCategoryID: 2,
			},
			Token:          token1,
			ExpectedStatus: 204,
		},
		{
			Name:  "On update pet, should return 404 when pet ID doesn't exists in DB",
			Token: token1,
			ID:    10000,
			In: model.PetRequest{
				Name:           "update_name",
				Status:         "sleeping",
				SpeciesID:      2,
				SizeCategoryID: 2,
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
			_ = writer.WriteField("status", test.In.Status)
			_ = writer.WriteField("speciesId", strconv.Itoa(int(test.In.SpeciesID)))
			_ = writer.WriteField("sizeCategoryId", strconv.Itoa(int(test.In.SizeCategoryID)))

			formFile, err := writer.CreateFormFile("image", "image/test.jpeg")
			if err != nil {
				t.Fatalf("error creating form file: %v", err)
			}

			buf, err := os.Open("image/test.jpeg")
			if err != nil {
				t.Fatalf("error opening file: %v", err)
			}
			defer buf.Close()

			_, err = io.Copy(formFile, buf)
			if err != nil {
				t.Fatalf("error sending image: %v", err)
			}

			writer.Close()

			req, err := http.NewRequest("PUT", fmt.Sprintf("/pets/%d", test.ID), body)
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			req.Header.Set("Content-Type", writer.FormDataContentType())
			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))

			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code, w.Body.String())
		})
	}
}

func TestDeletePet(t *testing.T) {
	token1, _, _ := helper.CreateJWT(1)

	tests := []PetTestTable[any]{
		{
			Name:           "On delete pet, should return 204 when pet ID exists in DB",
			Token:          token1,
			ID:             1,
			ExpectedStatus: 204,
		},
		{
			Name:           "On delete pet, should return 404 when pet ID doesn't exists in DB",
			Token:          token1,
			ID:             10000,
			ExpectedStatus: 404,
		},
	}
	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			db := setup.SetupTest(t)
			r := setup.Setup(db)

			w := httptest.NewRecorder()

			req, err := http.NewRequest("DELETE", fmt.Sprintf("/pets/%d", test.ID), nil)
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))
			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code, w.Body.String())
		})
	}
}
