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

func TestGetBookedPet(t *testing.T) {
	token1, _, _ := helper.CreateJWT(1)
	token2, _, _ := helper.CreateJWT(2)
	testPetDto := []model.PetDTO{
		{
			ID:       1,
			Name:     "Buddy",
			ImageUrl: "test.com/image/dog.jpeg",
			Status:   "idle",
			PetCategory: model.PetCategoryDTO{
				ID:   1,
				Name: "small dogs",
				SizeCategory: model.SizeCategory{
					ID: 1,
					Name: "small",
					MinWeight: 0,
					MaxWeight: 10,
				},
			},
			Owner: model.UserDTO{
				ID:       1,
				Name:     "John Doe",
				Email:    "john@example.com",
				ImageUrl: "test.com/image/test.jpeg",
				Role: model.Role{
					ID: 1,
					Name: "pet owner",
				},
			},
		},
	}

	tests := []PetDaycareTestTable[any]{
		{
			Name:           "On get booked pets, should return pets if daycare ID exists in DB",
			ID:             1,
			Token:          token2,
			ExpectedStatus: 200,
			ExpectedOutput: model.GetBookedPetsResponse{
				Data: testPetDto,
			},
		},
		{
			Name:           "On get booked pets, should return empty array if no pet is booked on pet daycare",
			ID:             2,
			Token:          token2,
			ExpectedStatus: 200,
			ExpectedOutput: model.GetBookedPetsResponse{Data: []model.PetDTO{}},
		},
		{
			Name:           "On get booked pets, should return 200 if user is not the owner of pet daycare",
			ID:             1,
			Token:          token1,
			ExpectedStatus: 200,
			ExpectedOutput: model.GetBookedPetsResponse{Data: []model.PetDTO{}},
		},
	}
	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			db := setup.SetupTest(t)
			r := setup.Setup(db)

			w := httptest.NewRecorder()

			req, err := http.NewRequest("GET", fmt.Sprintf("/daycare/%d/pets", test.ID), nil)
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))
			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code, w.Body.String())

			if w.Code == 200 {
				var res model.GetBookedPetsResponse
				resBody, _ := io.ReadAll(w.Body)

				if err := json.Unmarshal(resBody, &res); err != nil {
					t.Errorf("json Unmarshal err: %v", err)
				}

				for i, _ := range res.Data {
					res.Data[i].Owner.CreatedAt = ""
				}

				assert.Equal(t, test.ExpectedOutput, res)
				t.Logf("get booked pets:\n%+v", res)
			}

		})
	}
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
				// Price:             150000.0,
				// PricingType:       "day",
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
					Role: model.Role{
						ID: 2,
						Name: "pet daycare provider",
					},
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
				// Price:             150000.0,
				// PricingType:       "day",
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
					Role: model.Role{
						ID: 2,
						Name: "pet daycare provider",
					},
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
			ID:   1,
			In: model.GetSlotRequest{
				PetCategoryID: 1,
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
				fmt.Sprintf("/daycare/%d/slot?pet-category=%d&year=%d&month=%d", test.ID, test.In.PetCategoryID, test.In.Year, test.In.Month),
				nil)
			if err != nil {
				t.Errorf("http NewRequest err: %v", err)
			}
			req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", test.Token))
			r.ServeHTTP(w, req)

			assert.Equal(t, test.ExpectedStatus, w.Code, w.Body.String())

			if w.Code == 200 {
				var res model.ListData[model.SlotsResponse]
				resBody, _ := io.ReadAll(w.Body)

				if err := json.Unmarshal(resBody, &res); err != nil {
					t.Errorf("json Unmarshal err: %v", err)
				}

				t.Logf("pet daycare:\n%+v", res.Data)
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
