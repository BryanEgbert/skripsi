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

	bookedSlotStatus := []model.BookedSlotStatus{
		{ID: 1, Name: "Waiting for confirmation"},
		{ID: 2, Name: "Confirmed"},
		{ID: 3, Name: "Rejected"},
		{ID: 4, Name: "Done"},
		{ID: 5, Name: "Cancelled"},
	}

	if err := db.Create(&bookedSlotStatus).Error; err != nil {
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

	five := float32(5.0)
	ten := float32(10)
	twentyFive := float32(25)
	fortyFive := float32(45)

	// Insert SizeCategory records
	sizeCategories := []model.SizeCategory{
		{Name: "miniature", MinWeight: 1, MaxWeight: &five},
		{Name: "small", MinWeight: 5, MaxWeight: &ten},
		{Name: "medium", MinWeight: 10, MaxWeight: &twentyFive},
		{Name: "large", MinWeight: 25, MaxWeight: &fortyFive},
		{Name: "giant", MinWeight: 45},
		{Name: "all size", MinWeight: 0},
	}
	if err := db.Create(&sizeCategories).Error; err != nil {
		return err
	}

	// Insert Species records
	petCategory := []model.PetCategory{
		{Name: "miniature dogs", SizeCategory: sizeCategories[0]},
		{Name: "small dogs", SizeCategory: sizeCategories[1]},
		{Name: "medium dogs", SizeCategory: sizeCategories[2]},
		{Name: "large dogs", SizeCategory: sizeCategories[3]},
		{Name: "giant dogs", SizeCategory: sizeCategories[4]},
		{Name: "cats"},
		{Name: "rabbits"},
	}
	if err := db.Create(&petCategory).Error; err != nil {
		return err
	}

	password1, _ := helper.HashPassword("test")

	vetSpecialty := []model.VetSpecialty{
		vetSpecialties[0],
		vetSpecialties[1],
		vetSpecialties[2],
	}

	dummyImgUrl := "https://picsum.photos/id/1/200/300"

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
			Name:        "Happy Paws",
			Address:     "123 Bark St",
			Latitude:    -6.17722188,
			Longitude:   106.7909223,
			Locality:    "Grogol Petamburan",
			Location:    "Happy Paws",
			OpeningHour: model.CustomTime{Time: time.Now()},
			ClosingHour: model.CustomTime{Time: time.Now().Add(1 * time.Hour)},
			// Price:         100000.0,
			OwnerID:       users[1].ID,
			DailyWalks:    dailyWalks[1],
			DailyPlaytime: dailyPlaytimes[1],
		},
		{
			Name:        "DOG Daycare Jakarta",
			Address:     "Jl. Abdul Majid Raya No.31, Cipete Sel., Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12410",
			Location:    "DOG daycare jakarta",
			Description: "DOG daycare jakarta desc",
			Latitude:    -6.266167,
			Longitude:   106.808214,
			Locality:    "Grogol Petamburan",
			OpeningHour: model.CustomTime{Time: time.Now()},
			ClosingHour: model.CustomTime{Time: time.Now().Add(1 * time.Hour)},
			// Price:             150000.0,
			OwnerID:           users[2].ID,
			DailyWalks:        dailyWalks[1],
			BookedNum:         1,
			DailyPlaytime:     dailyPlaytimes[3],
			GroomingAvailable: true,
			FoodProvided:      true,
			FoodBrand:         "Pedigree",
		},
		{
			Name:        "Happy Paws 2",
			Address:     "123 Bark St",
			Location:    "Central Park Mall",
			Latitude:    -6.22400791,
			Longitude:   106.5889773,
			Locality:    "Grogol Petamburan",
			OpeningHour: model.CustomTime{Time: time.Now()},
			ClosingHour: model.CustomTime{Time: time.Now().Add(1 * time.Hour)},
			// Price:         100000.0,
			OwnerID:       users[5].ID,
			DailyWalks:    dailyWalks[1],
			DailyPlaytime: dailyPlaytimes[1],
			BookedNum:     10,
		},
	}

	if err := db.Create(&daycare).Error; err != nil {
		return err
	}

	slots := []model.Slots{
		{DaycareID: daycare[0].ID, PetCategoryID: 1, MaxNumber: 5, Price: 100000.0},
		{DaycareID: daycare[0].ID, PetCategoryID: 2, MaxNumber: 8, Price: 100000.0},
		{DaycareID: daycare[1].ID, PetCategoryID: 1, MaxNumber: 20, Price: 100000.0},
	}

	if err := db.Create(&slots).Error; err != nil {
		return err
	}

	petImg := "https://picsum.photos/id/237/200/300"
	pet := []model.Pet{
		{
			Name: "Buddy", ImageUrl: &petImg, Status: "idle", OwnerID: users[0].ID, PetCategoryID: 1,
		},
		{
			Name: "Buddy2", ImageUrl: &petImg, Status: "idle", OwnerID: users[0].ID, PetCategoryID: 1,
		},
	}

	if err := db.Create(&pet).Error; err != nil {
		return err
	}

	vaccineRecordImgUrl := "https://picsum.photos/id/28/200/300"

	vaccineRecords := []model.VaccineRecord{
		{
			DateAdministered: "2024-03-10",
			NextDueDate:      "2025-03-10",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-02-15",
			NextDueDate:      "2025-02-15",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-03-10",
			NextDueDate:      "2025-03-10",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-02-15",
			NextDueDate:      "2025-02-15",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-03-10",
			NextDueDate:      "2025-03-10",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-02-15",
			NextDueDate:      "2025-02-15",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-03-10",
			NextDueDate:      "2025-03-10",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-02-15",
			NextDueDate:      "2025-02-15",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-03-10",
			NextDueDate:      "2025-03-10",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-02-15",
			NextDueDate:      "2025-02-15",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-03-10",
			NextDueDate:      "2025-03-10",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-02-15",
			NextDueDate:      "2025-02-15",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-03-10",
			NextDueDate:      "2025-03-10",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-02-15",
			NextDueDate:      "2025-02-15",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-03-10",
			NextDueDate:      "2025-03-10",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-02-15",
			NextDueDate:      "2025-02-15",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-03-10",
			NextDueDate:      "2025-03-10",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-02-15",
			NextDueDate:      "2025-02-15",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-03-10",
			NextDueDate:      "2025-03-10",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-02-15",
			NextDueDate:      "2025-02-15",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-03-10",
			NextDueDate:      "2025-03-10",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID, // Ensure the pet exists
		},
		{
			DateAdministered: "2024-02-15",
			NextDueDate:      "2025-02-15",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID, // Ensure the pet exists
		},
	}

	if err := db.Create(&vaccineRecords).Error; err != nil {
		return err
	}

	bookedSlot := []model.BookedSlot{
		{
			UserID:    users[0].ID,
			DaycareID: daycare[0].ID,
			Pet:       []model.Pet{pet[0]},
			StartDate: time.Date(2025, time.February, 13, 0, 0, 0, 0, time.Local),
			EndDate:   time.Date(2025, time.February, 15, 0, 0, 0, 0, time.Local),
			StatusID:  1,
			Address: model.BookedSlotAddress{
				Name:      "Central Park",
				Address:   "Jln. Tanjung Duren",
				Latitude:  0.0,
				Longitude: 0.0,
			},
		},
		{
			UserID:    users[0].ID,
			DaycareID: daycare[1].ID,
			Pet:       []model.Pet{pet[1]}, StartDate: time.Now(), EndDate: time.Now().AddDate(0, 0, 3),
			StatusID: 1,
		},
	}

	if err := db.Create(&bookedSlot).Error; err != nil {
		return err
	}

	bookedSlotDaily := []model.BookedSlotsDaily{
		{
			DaycareID: daycare[0].ID,
			SlotCount: 1,
			Date:      time.Date(2025, time.February, 13, 0, 0, 0, 0, time.Local),
		},
		{
			DaycareID: daycare[0].ID,
			SlotCount: 1,
			Date:      time.Date(2025, time.February, 14, 0, 0, 0, 0, time.Local),
		},
		{
			DaycareID: daycare[0].ID,
			SlotCount: 1,
			Date:      time.Date(2025, time.February, 15, 0, 0, 0, 0, time.Local),
		},
	}

	if err := db.Create(&bookedSlotDaily).Error; err != nil {
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
		SlotID: slots[0].ID, DaycareID: slots[0].DaycareID, ReducedCount: 2, TargetDate: time.Date(2025, time.February, 13, 0, 0, 0, 0, time.Local),
	}

	if err := db.Create(&reduceSlots).Error; err != nil {
		return err
	}

	thumbnails := []model.Thumbnail{
		{DaycareID: daycare[0].ID, ImageUrl: dummyImgUrl},
		{DaycareID: daycare[1].ID, ImageUrl: dummyImgUrl},
	}

	if err := db.Create(&thumbnails).Error; err != nil {
		return err
	}

	transaction := model.Transaction{
		UserID:       users[0].ID,
		PetDaycareID: daycare[0].ID,
		BookedSlot:   bookedSlot[0],
	}

	if err := db.Create(&transaction).Error; err != nil {
		return err
	}

	return nil
}
