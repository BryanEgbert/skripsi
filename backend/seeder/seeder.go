package seeder

import (
	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

func SeedTable(db *gorm.DB) error {
	roles := []model.Role{
		{
			ID:   1,
			Name: "pet owner",
		},
		{
			ID:   2,
			Name: "pet daycare provider",
		},
		{
			ID:   3,
			Name: "vet",
		},
	}

	if err := db.Create(&roles).Error; err != nil {
		return err
	}

	dailyWalks := []model.DailyWalks{
		{
			ID:   1,
			Name: "No walks provided",
		},
		{
			ID:   2,
			Name: "one walk a day",
		},
		{
			ID:   3,
			Name: "two walks a day",
		},
		{
			ID:   4,
			Name: "more than two walks a day",
		},
	}

	if err := db.Create(&dailyWalks).Error; err != nil {
		return err
	}

	dailyPlaytimes := []model.DailyPlaytime{
		{ID: 1, Name: "No playtime provided"},
		{ID: 2, Name: "one play session a day"},
		{ID: 3, Name: "two play session a day"},
		{ID: 4, Name: "more than two play session a day"},
	}
	db.Create(&dailyPlaytimes)

	// Insert VetSpecialty records
	vetSpecialties := []model.VetSpecialty{
		{Name: "General Practice"},
		{Name: "Preventive Medicine"},
		{Name: "Emergency & Critical Care"},
		{Name: "Internal Medicine"},
		{Name: "Cardiology"},
		{Name: "Neurology"},
		{Name: "Oncology"},
		{Name: "Gastroenterology"},
		{Name: "Dermatology & Allergy Care"},
		{Name: "Dentistry & Oral Surgery"},
		{Name: "Behavioral Medicine"},
		{Name: "Surgery & Orthopedics"},
		{Name: "Soft Tissue Surgery"},
		{Name: "Orthopedic Surgery"},
		{Name: "Ophthalmology"},
		{Name: "Rehabilitation & Physical Therapy"},
		{Name: "Exotic & Small Animal Care"},
	}
	if err := db.Create(&vetSpecialties).Error; err != nil {
		return err
	}

	// Insert Species records
	species := []model.Species{
		{Name: "small sized dog, cats, parrots"},
		{Name: "medium sized dog"},
		{Name: "large sized dog"},
	}
	if err := db.Create(&species).Error; err != nil {
		return err
	}

	// Insert SizeCategory records
	sizeCategories := []model.SizeCategory{
		{Name: "small", MinWeight: 0, MaxWeight: 10},
		{Name: "medium", MinWeight: 11, MaxWeight: 26},
		{Name: "large", MinWeight: 27, MaxWeight: 45},
		{Name: "giant", MinWeight: 45, MaxWeight: 100},
	}
	if err := db.Create(&sizeCategories).Error; err != nil {
		return err
	}

	password1, _ := helper.HashPassword("test")

	user1Vet := []model.VetSpecialty{
		vetSpecialties[0],
		vetSpecialties[1],
		vetSpecialties[2],
	}

	user := []model.User{
		{
			Name:         "test",
			Email:        "test@mail.com",
			Password:     password1,
			ImageUrl:     "testimage",
			RoleID:       1,
			VetSpecialty: &user1Vet,
		},
	}

	if err := db.Create(&user).Error; err != nil {
		return err
	}

	return nil
}
