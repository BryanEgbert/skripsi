package test

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/setup"
	"github.com/stretchr/testify/assert"
)

type PetDaycareTestTable[T any] struct {
	Name           string
	ID             int
	In             T
	Token          string
	ExpectedStatus int
	ExpectedOutput any
}

type UserCoordinate struct {
	Lat  float64
	Long float64
}

func TestGetPetDaycare(t *testing.T) {
	token1, _, _ := helper.CreateJWT(1)

	tests := []PetDaycareTestTable[UserCoordinate]{
		{
			Name: "On get pet daycare, should return pet daycare if ID exists in DB",
			ID:   2,
			In: UserCoordinate{
				Long: -6.322449,
				Lat:  106.870233,
			},
			Token:          token1,
			ExpectedStatus: 200,
			ExpectedOutput: model.GetPetDaycareDetailResponse{
				ID:                2,
				Name:              "DOG Daycare Jakarta",
				Address:           "Jl. Abdul Majid Raya No.31, Cipete Sel., Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12410",
				Price:             150000.0,
				PricingType:       "day",
				Description:       "DOG daycare jakarta desc",
				BookedNum:         1,
				Distance:          1.140617942364012e+07,
				AverageRating:     4.5,
				RatingCount:       2,
				HasPickupService:  false,
				MustBeVaccinated:  false,
				GroomingAvailable: true,
				FoodProvided:      true,
				FoodBrand:         "Pedigree",
				DailyWalks: model.DailyWalks{
					ID:   2,
					Name: "one walk a day",
				},
				DailyPlaytime: model.DailyPlaytime{
					ID:   4,
					Name: "more than two play session a day",
				},
				ThumbnailURLs: []string{
					"test.com/image/thumbnail2.jpg",
				},
				Owner: model.UserDTO{
					ID:       3,
					Name:     "Jane Smith Daycare2",
					Email:    "daycare@example.com",
					ImageUrl: "test.com/image/test.jpeg",
					RoleID:   2,
				},
			},
		},
		{
			Name: "On get pet daycare, should return pet daycare if ID exists in DB and distance is 0 if lat and long is 0",
			ID:   2,
			In: UserCoordinate{
				Lat:  0.0,
				Long: 0.0,
			},
			Token:          token1,
			ExpectedStatus: 200,
			ExpectedOutput: model.GetPetDaycareDetailResponse{
				ID:                2,
				Name:              "DOG Daycare Jakarta",
				Address:           "Jl. Abdul Majid Raya No.31, Cipete Sel., Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12410",
				Price:             150000.0,
				PricingType:       "day",
				Description:       "DOG daycare jakarta desc",
				BookedNum:         1,
				Distance:          0,
				AverageRating:     4.5,
				RatingCount:       2,
				HasPickupService:  false,
				MustBeVaccinated:  false,
				GroomingAvailable: true,
				FoodProvided:      true,
				FoodBrand:         "Pedigree",
				DailyWalks: model.DailyWalks{
					ID:   2,
					Name: "one walk a day",
				},
				DailyPlaytime: model.DailyPlaytime{
					ID:   4,
					Name: "more than two play session a day",
				},
				ThumbnailURLs: []string{
					"test.com/image/thumbnail2.jpg",
				},
				Owner: model.UserDTO{
					ID:       3,
					Name:     "Jane Smith Daycare2",
					Email:    "daycare@example.com",
					ImageUrl: "test.com/image/test.jpeg",
					RoleID:   2,
				},
			},
		},
		{
			Name: "On get pet daycare, should return error if ID doesn't exists in DB",
			ID:   10000,
			In: UserCoordinate{
				Long: -6.322449,
				Lat:  106.870233,
			},
			Token:          token1,
			ExpectedStatus: 404,
		},
	}
	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			db := setup.SetupTest(t)
			r := setup.Setup(db)

			w := httptest.NewRecorder()

			req, err := http.NewRequest("GET", fmt.Sprintf("/daycare/%d?lat=%f&long=%f", test.ID, test.In.Lat, test.In.Long), nil)
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))
			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code, w.Body.String())

			if w.Code == 200 {
				var res model.GetPetDaycareDetailResponse
				resBody, _ := io.ReadAll(w.Body)

				if err := json.Unmarshal(resBody, &res); err != nil {
					t.Errorf("json Unmarshal err: %v", err)
				}

				if assert.NotEmpty(t, res.CreatedAt) && assert.NotEmpty(t, res.Owner.CreatedAt) {
					res.CreatedAt = ""
					res.Owner.CreatedAt = ""
					assert.Equal(t, test.ExpectedOutput, res)
				}
				t.Logf("pet daycare:\n%+v", res)
			}

		})
	}
}

func TestGetPetDaycareSlot(t *testing.T) {
	token1, _, _ := helper.CreateJWT(1)

	tests := []PetDaycareTestTable[model.GetSlotRequest]{
		{
			Name: "On get pet daycare slot, should return slot of the month",
			ID:   2,
			In: model.GetSlotRequest{
				SpeciesID:      1,
				SizeCategoryID: 1,
				Year:           2025,
				Month:          2,
			},
			Token:          token1,
			ExpectedStatus: 200,
		},
	}
	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			db := setup.SetupTest(t)
			r := setup.Setup(db)

			w := httptest.NewRecorder()

			req, err := http.NewRequest("GET",
				fmt.Sprintf("/daycare/%d/slot?species=%d&size=%d&year=%d&month=%d", test.ID, test.In.SpeciesID, test.In.SizeCategoryID, test.In.Year, test.In.Month),
				nil)
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))
			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code, w.Body.String())

			if w.Code == 200 {
				var res model.GetPetDaycareDetailResponse
				resBody, _ := io.ReadAll(w.Body)

				if err := json.Unmarshal(resBody, &res); err != nil {
					t.Errorf("json Unmarshal err: %v", err)
				}

				t.Logf("pet daycare:\n%+v", res)
			}

		})
	}
}

func TestDeletePetDaycare(t *testing.T) {
	token2, _, _ := helper.CreateJWT(2)
	token5, _, _ := helper.CreateJWT(5)
	token1, _, _ := helper.CreateJWT(1)

	tests := []PetDaycareTestTable[any]{
		{
			Name:           "On delete pet daycare, should return 204 when pet daycare ID exists in DB and owner ID match with token user ID",
			ID:             3,
			Token:          token5,
			ExpectedStatus: 204,
		},
		{
			Name:           "On delete pet daycare, should return 403 when pet still book in pet daycare",
			ID:             1,
			Token:          token2,
			ExpectedStatus: 500,
		},
		{
			Name:           "On delete pet daycare, should return 204 when pet daycare ID exists in DB and owner ID doesn't match with token user ID",
			ID:             3,
			Token:          token1,
			ExpectedStatus: 204,
		},
		{
			Name:           "On delete pet daycare, should return 204 when pet daycare ID doesn't exists in DB",
			ID:             10000,
			Token:          token2,
			ExpectedStatus: 204,
		},
	}
	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			db := setup.SetupTest(t)
			r := setup.Setup(db)

			w := httptest.NewRecorder()

			req, err := http.NewRequest("DELETE", fmt.Sprintf("/daycare/%d", test.ID), nil)
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))
			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code, w.Body.String())
		})
	}
}

// func TestUpdateUser(t *testing.T) {
// 	token3, _, _ := helper.CreateJWT(3)
// 	token4, _, _ := helper.CreateJWT(4)
// 	token10000, _, _ := helper.CreateJWT(10000)

// 	updateVetSpecialties := []uint{2, 4, 5}

// 	tests := []PetDaycareTestTable[model.UpdateUserRequest]{
// 		{
// 			Name: "On update user, should return 200 and updated user",
// 			In: model.UpdateUserRequest{
// 				ID:     4,
// 				Name:   "update name",
// 				Email:  "update@example.com",
// 				RoleID: 1,
// 			},
// 			Token:          token4,
// 			ExpectedStatus: 200,
// 			ExpectedOutput: model.UpdateUserDTO{
// 				ID:     4,
// 				Name:   "update name",
// 				Email:  "update@example.com",
// 				RoleID: 1,
// 			},
// 		},
// 		{
// 			Name: "On update user, should return 200 and updated user and vet specialties",
// 			In: model.UpdateUserRequest{
// 				ID:             3,
// 				Name:           "update vet name",
// 				Email:          "vetupdate@example.com",
// 				RoleID:         3,
// 				VetSpecialtyID: &updateVetSpecialties,
// 			},
// 			Token:          token3,
// 			ExpectedStatus: 200,
// 			ExpectedOutput: model.UpdateUserDTO{
// 				ID:             3,
// 				Name:           "update vet name",
// 				Email:          "vetupdate@example.com",
// 				RoleID:         3,
// 				VetSpecialtyID: &updateVetSpecialties,
// 				ImageUrl:       "image/test.jpg",
// 			},
// 		},
// 		{
// 			Name:  "On update user, should return 404 when user ID doesn't exists in DB",
// 			Token: token10000,
// 			In: model.UpdateUserRequest{
// 				ID:     10000,
// 				Name:   "dummy name",
// 				Email:  "dummy@example.com",
// 				RoleID: 1,
// 			},
// 			ExpectedStatus: 404,
// 		},
// 	}
// 	for _, test := range tests {
// 		t.Run(test.Name, func(t *testing.T) {
// 			db := setup.SetupTest(t)
// 			r := setup.Setup(db)

// 			w := httptest.NewRecorder()

// 			body := &bytes.Buffer{}
// 			writer := multipart.NewWriter(body)

// 			_ = writer.WriteField("name", test.In.Name)
// 			_ = writer.WriteField("email", test.In.Email)
// 			_ = writer.WriteField("roleId", strconv.Itoa(int(test.In.RoleID)))
// 			if test.In.VetSpecialtyID != nil {
// 				for _, vetSpecialtyID := range *test.In.VetSpecialtyID {
// 					_ = writer.WriteField("vetSpecialtyId[]", strconv.Itoa(int(vetSpecialtyID)))
// 				}
// 			}

// 			writer.Close()

// 			req, err := http.NewRequest("PUT", "/users", body)
// 			if err != nil {
// 				t.Errorf("http NewRequest err: %v", err)
// 			}
// 			req.Header.Set("Content-Type", writer.FormDataContentType())
// 			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))

// 			r.ServeHTTP(w, req)

// 			assert.Equal(t, test.ExpectedStatus, w.Code, w.Body.String())

// 			if w.Code == 200 {
// 				var res model.UpdateUserDTO
// 				resBody, _ := io.ReadAll(w.Body)

// 				if err := json.Unmarshal(resBody, &res); err != nil {
// 					t.Errorf("json Unmarshal err: %v", err)
// 				}

// 				assert.ObjectsAreEqual(test.ExpectedOutput, res)
// 			}
// 		})
// 	}
// }

// func TestUpdatePassword(t *testing.T) {
// 	token4, _, _ := helper.CreateJWT(4)
// 	token10000, _, _ := helper.CreateJWT(10000)

// 	tests := []PetDaycareTestTable[model.UpdatePasswordRequest]{
// 		{
// 			Name:  "On update password, should return 204 when user ID exists in DB and newPassword is not empty",
// 			Token: token4,
// 			In: model.UpdatePasswordRequest{
// 				NewPassword: "newPassword",
// 			},
// 			ExpectedStatus: 204,
// 		},
// 		{
// 			Name:  "On update password, should return 404 when newPassword is empty",
// 			Token: token4,
// 			In: model.UpdatePasswordRequest{
// 				NewPassword: "",
// 			},
// 			ExpectedStatus: 400,
// 		},
// 		{
// 			Name:  "On update password, should return 404 when user ID doesn't exists in DB",
// 			Token: token10000,
// 			In: model.UpdatePasswordRequest{
// 				NewPassword: "newPassword",
// 			},
// 			ExpectedStatus: 404,
// 		},
// 	}
// 	for _, test := range tests {
// 		t.Run(test.Name, func(t *testing.T) {
// 			db := setup.SetupTest(t)
// 			r := setup.Setup(db)

// 			w := httptest.NewRecorder()

// 			reqJson, err := json.Marshal(test.In)
// 			if err != nil {
// 				t.Errorf("json Marshal err: %v", err)
// 			}

// 			req, err := http.NewRequest("PATCH", "/users/password", strings.NewReader(string(reqJson)))
// 			if err != nil {
// 				t.Errorf("http NewRequest err: %v", err)
// 			}
// 			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))
// 			r.ServeHTTP(w, req)

// 			assert.Equal(t, test.ExpectedStatus, w.Code, w.Body.String())
// 		})
// 	}
// }
