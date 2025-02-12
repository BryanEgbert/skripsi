package seeder

import (
	"time"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

func SeedTable(db *gorm.DB) error {
	roles := []model.Role{
		{ID: 1, Name: "pet owner"},
		{ID: 2, Name: "pet daycare provider"},
		{ID: 3, Name: "vet"},
	}

	if err := db.Create(&roles).Error; err != nil {
		return err
	}

	dailyWalks := []model.DailyWalks{
		{ID: 1, Name: "No walks provided"},
		{ID: 2, Name: "one walk a day"},
		{ID: 3, Name: "two walks a day"},
		{ID: 4, Name: "more than two walks a day"},
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
		{Name: "dogs"},
		{Name: "cats"},
		{Name: "rabbits"},
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
		{Name: "all size", MinWeight: 0, MaxWeight: 100},
	}
	if err := db.Create(&sizeCategories).Error; err != nil {
		return err
	}

	password1, _ := helper.HashPassword("test")

	vetSpecialty := []model.VetSpecialty{
		vetSpecialties[0],
		vetSpecialties[1],
		vetSpecialties[2],
	}

	dummyImgUrl := "test.com/image/test.jpeg"

	users := []model.User{
		{Name: "John Doe", Email: "john@example.com", Password: password1, RoleID: 1, ImageUrl: &dummyImgUrl},
		{Name: "Jane Smith", Email: "jane@example.com", Password: password1, RoleID: 2, ImageUrl: &dummyImgUrl},
		{Name: "Jane Smith Daycare2", Email: "daycare@example.com", Password: password1, RoleID: 2, ImageUrl: &dummyImgUrl},
		{Name: "Dr. Vet", Email: "vet@example.com", Password: password1, RoleID: 3, VetSpecialty: &vetSpecialty, ImageUrl: &dummyImgUrl},
		{Name: "Delete user", Email: "delete@example.com", Password: password1, RoleID: 1},
		{Name: "Jane Smith Daycare3", Email: "daycare3@example.com", Password: password1, RoleID: 2, ImageUrl: &dummyImgUrl},
	}

	if err := db.Create(&users).Error; err != nil {
		return err
	}

	daycare := []model.PetDaycare{
		{
			Name:          "Happy Paws",
			Address:       "123 Bark St",
			Latitude:      40.7128,
			Longitude:     -74.0060,
			Price:         100000.0,
			OwnerID:       users[1].ID,
			DailyWalks:    dailyWalks[1],
			DailyPlaytime: dailyPlaytimes[1],
		},
		{
			Name:              "DOG Daycare Jakarta",
			Address:           "Jl. Abdul Majid Raya No.31, Cipete Sel., Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12410",
			Description:       "DOG daycare jakarta desc",
			Latitude:          -6.266167,
			Longitude:         106.808214,
			Price:             150000.0,
			OwnerID:           users[2].ID,
			DailyWalks:        dailyWalks[1],
			BookedNum:         1,
			DailyPlaytime:     dailyPlaytimes[3],
			GroomingAvailable: true,
			FoodProvided:      true,
			FoodBrand:         "Pedigree",
		},
		{
			Name:          "Happy Paws 2",
			Address:       "123 Bark St",
			Latitude:      40.7128,
			Longitude:     -74.0060,
			Price:         100000.0,
			OwnerID:       users[5].ID,
			DailyWalks:    dailyWalks[1],
			DailyPlaytime: dailyPlaytimes[1],
		},
	}

	if err := db.Create(&daycare).Error; err != nil {
		return err
	}

	slots := []model.Slots{
		{DaycareID: daycare[0].ID, SpeciesID: 1, SizeCategoryID: 1, MaxNumber: 5},
		{DaycareID: daycare[0].ID, SpeciesID: 2, SizeCategoryID: 2, MaxNumber: 8},
		{DaycareID: daycare[1].ID, SpeciesID: 1, SizeCategoryID: 5, MaxNumber: 20},
	}

	if err := db.Create(&slots).Error; err != nil {
		return err
	}

	petImg := "test.com/image/dog.jpeg"
	pet := []model.Pet{
		{
			Name: "Buddy", ImageUrl: &petImg, Status: "idle", OwnerID: users[0].ID, SpeciesID: 1, SizeID: 1,
		},
		{
			Name: "Buddy2", ImageUrl: &petImg, Status: "idle", OwnerID: users[0].ID, SpeciesID: 1, SizeID: 2,
		},
	}

	if err := db.Create(&pet).Error; err != nil {
		return err
	}

	bookedSlot := []model.BookedSlot{
		{
			UserID:    users[0].ID,
			DaycareID: daycare[0].ID,
			PetID:     pet[0].ID, StartDate: time.Now(), EndDate: time.Now().AddDate(0, 0, 1),
		},
		{
			UserID:    users[0].ID,
			DaycareID: daycare[1].ID,
			PetID:     pet[1].ID, StartDate: time.Now(), EndDate: time.Now().AddDate(0, 0, 3),
		},
	}

	if err := db.Create(&bookedSlot).Error; err != nil {
		return err
	}

	review := []model.Reviews{
		{
			DaycareID: daycare[0].ID, UserID: users[0].ID, Name: "John Doe", Rate: 5, Description: "Great daycare!",
		},
		{
			DaycareID: daycare[1].ID, UserID: users[0].ID, Name: "Nice", Rate: 5, Description: "Great daycare!",
		},
		{
			DaycareID: daycare[1].ID, UserID: users[1].ID, Name: "Nice", Rate: 4, Description: "Great daycare!",
		},
	}

	if err := db.Create(&review).Error; err != nil {
		return err
	}

	reduceSlots := model.ReduceSlots{
		SlotID: slots[0].ID, ReducedCount: 2, TargetDate: time.Now(),
	}

	if err := db.Create(&reduceSlots).Error; err != nil {
		return err
	}

	thumbnails := []model.Thumbnail{
		{DaycareID: daycare[0].ID, ImageUrl: "test.com/image/thumbnail1.jpg"},
		{DaycareID: daycare[1].ID, ImageUrl: "test.com/image/thumbnail2.jpg"},
	}

	if err := db.Create(&thumbnails).Error; err != nil {
		return err
	}

	transaction := model.Transaction{
		PetDaycareID: daycare[0].ID, BookedSlotID: bookedSlot[0].ID, Status: "completed",
	}

	if err := db.Create(&transaction).Error; err != nil {
		return err
	}

	return nil
}
