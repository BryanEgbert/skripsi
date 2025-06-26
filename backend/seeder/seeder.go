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

	pricingTypes := []model.PricingType{
		{ID: 1, Name: "day"},
		{ID: 2, Name: "night"},
	}

	if err := db.Create(&pricingTypes).Error; err != nil {
		return err
	}

	bookedSlotStatus := []model.BookedSlotStatus{
		{ID: 1, Name: "Waiting for confirmation"},
		{ID: 2, Name: "Confirmed"},
		{ID: 3, Name: "Rejected"},
		{ID: 4, Name: "Done"},
		{ID: 5, Name: "Cancelled"},
		{ID: 6, Name: "Ignored"},
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
	// twelve := float32(12)
	twentyFive := float32(25)
	fortyFive := float32(45)

	// Insert SizeCategory records
	sizeCategories := []model.SizeCategory{
		{Name: "miniature", MinWeight: 1, MaxWeight: &five},
		{Name: "small", MinWeight: 5, MaxWeight: &ten},
		{Name: "medium", MinWeight: 10, MaxWeight: &twentyFive},
		{Name: "large", MinWeight: 25, MaxWeight: &fortyFive},
		{Name: "giant", MinWeight: 45},
		{Name: "cat", MinWeight: 1},
		{Name: "bunnies", MinWeight: 1},
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
		{Name: "cats", SizeCategory: sizeCategories[5]},
		{Name: "bunnies", SizeCategory: sizeCategories[6]},
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
			Name:             "Happy Paws",
			Address:          "123 Bark St",
			Latitude:         -6.17722188,
			Longitude:        106.7909223,
			Locality:         "Grogol Petamburan",
			Location:         "Happy Paws",
			OpeningHour:      model.CustomTime{Time: time.Now()},
			ClosingHour:      model.CustomTime{Time: time.Now().Add(1 * time.Hour)},
			HasPickupService: true,
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
			OwnerID:          users[5].ID,
			DailyWalks:       dailyWalks[1],
			DailyPlaytime:    dailyPlaytimes[1],
			MustBeVaccinated: true,
			BookedNum:        2,
		},
	}

	if err := db.Create(&daycare).Error; err != nil {
		return err
	}

	slots := []model.Slots{
		{DaycareID: daycare[0].ID, PricingTypeID: 1, PetCategoryID: 1, MaxNumber: 5, Price: 100000.0},
		{DaycareID: daycare[0].ID, PricingTypeID: 1, PetCategoryID: 2, MaxNumber: 8, Price: 100000.0},
		{DaycareID: daycare[0].ID, PricingTypeID: 1, PetCategoryID: petCategory[5].ID, MaxNumber: 8, Price: 100000.0},
		{DaycareID: daycare[1].ID, PricingTypeID: 1, PetCategoryID: 1, MaxNumber: 20, Price: 100000.0},
		{DaycareID: daycare[2].ID, PricingTypeID: 2, PetCategoryID: 1, MaxNumber: 2, Price: 100000.0},
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
			DateAdministered: "2024-01-20",
			NextDueDate:      "2025-10-20",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID,
		},
		{
			DateAdministered: "2024-04-12",
			NextDueDate:      "2025-04-12",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID,
		},
		{
			DateAdministered: "2024-02-08",
			NextDueDate:      "2025-02-08",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID,
		},
		{
			DateAdministered: "2024-05-18",
			NextDueDate:      "2025-05-18",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID,
		},
		{
			DateAdministered: "2024-03-22",
			NextDueDate:      "2025-03-22",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID,
		},
		{
			DateAdministered: "2024-01-30",
			NextDueDate:      "2025-01-30",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID,
		},
		{
			DateAdministered: "2024-02-27",
			NextDueDate:      "2025-02-27",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID,
		},
		{
			DateAdministered: "2024-04-03",
			NextDueDate:      "2025-04-03",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID,
		},
		{
			DateAdministered: "2024-05-01",
			NextDueDate:      "2025-05-01",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID,
		},
		{
			DateAdministered: "2024-03-10",
			NextDueDate:      "2025-03-10",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID,
		},
		{
			DateAdministered: "2024-01-15",
			NextDueDate:      "2025-01-15",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID,
		},
		{
			DateAdministered: "2024-05-22",
			NextDueDate:      "2025-05-22",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID,
		},
		{
			DateAdministered: "2024-02-11",
			NextDueDate:      "2025-02-11",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID,
		},
		{
			DateAdministered: "2024-03-28",
			NextDueDate:      "2025-03-28",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID,
		},
		{
			DateAdministered: "2024-04-05",
			NextDueDate:      "2025-04-05",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID,
		},
		{
			DateAdministered: "2024-01-27",
			NextDueDate:      "2025-01-27",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID,
		},
		{
			DateAdministered: "2024-02-19",
			NextDueDate:      "2025-02-19",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID,
		},
		{
			DateAdministered: "2024-04-09",
			NextDueDate:      "2025-04-09",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID,
		},
		{
			DateAdministered: "2024-03-03",
			NextDueDate:      "2025-03-03",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID,
		},
		{
			DateAdministered: "2024-05-14",
			NextDueDate:      "2025-05-14",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID,
		},
		{
			DateAdministered: "2024-01-10",
			NextDueDate:      "2025-01-10",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[0].ID,
		},
		{
			DateAdministered: "2024-02-25",
			NextDueDate:      "2025-02-25",
			ImageURL:         vaccineRecordImgUrl,
			PetID:            pet[1].ID,
		},
	}

	if err := db.Create(&vaccineRecords).Error; err != nil {
		return err
	}

	savedAddress := []model.SavedAddress{
		{
			Name:      "Central Park",
			UserID:    users[0].ID,
			Address:   "Letjen S. Parman St No.Kav. 28, South Tanjung Duren, Grogol petamburan, West Jakarta City, Jakarta 11470",
			Latitude:  106.7884039,
			Longitude: -6.177132,
		},
	}

	if err := db.Create(&savedAddress).Error; err != nil {
		return err
	}

	var waitingConfirmation uint = 1
	var confirmed uint = 2
	// var done uint = 4
	bookedSlot := []model.BookedSlot{
		{
			UserID:    users[0].ID,
			SlotID:    slots[0].ID,
			DaycareID: daycare[0].ID,
			Pet:       []model.Pet{pet[0]},
			StartDate: time.Date(2025, time.February, 13, 0, 0, 0, 0, time.Local),
			EndDate:   time.Date(2025, time.February, 15, 0, 0, 0, 0, time.Local),
			StatusID:  &waitingConfirmation,
			AddressID: &savedAddress[0].ID,
		},
		{
			UserID:    users[0].ID,
			DaycareID: daycare[1].ID,
			Pet:       []model.Pet{pet[1]},
			StartDate: time.Now(),
			EndDate:   time.Now().AddDate(0, 0, 3),
			StatusID:  &waitingConfirmation,
		},
		{
			UserID:    users[0].ID,
			SlotID:    slots[3].ID,
			DaycareID: daycare[2].ID,
			Pet:       []model.Pet{pet[0]},
			StartDate: time.Date(2025, time.May, 26, 0, 0, 0, 0, time.Local),
			EndDate:   time.Date(2025, time.May, 30, 0, 0, 0, 0, time.Local),
			StatusID:  &confirmed,
			AddressID: &savedAddress[0].ID,
		},
		{
			UserID:    users[0].ID,
			SlotID:    slots[3].ID,
			DaycareID: daycare[2].ID,
			Pet:       []model.Pet{pet[1]},
			StartDate: time.Date(2025, time.May, 27, 0, 0, 0, 0, time.Local),
			EndDate:   time.Date(2025, time.May, 30, 0, 0, 0, 0, time.Local),
			StatusID:  &confirmed,
			AddressID: &savedAddress[0].ID,
		},
		{
			UserID:    users[0].ID,
			SlotID:    slots[1].ID,
			DaycareID: daycare[2].ID,
			Pet:       []model.Pet{pet[1], pet[0]},
			StartDate: time.Date(2025, time.April, 27, 0, 0, 0, 0, time.Local),
			EndDate:   time.Date(2025, time.April, 30, 0, 0, 0, 0, time.Local),
			StatusID:  &confirmed,
			AddressID: &savedAddress[0].ID,
		},
	}

	if err := db.Create(&bookedSlot).Error; err != nil {
		return err
	}

	bookedSlotDaily := []model.BookedSlotsDaily{
		{
			// DaycareID: daycare[0].ID,
			SlotID:    slots[0].ID,
			SlotCount: 1,
			Date:      time.Date(2025, time.February, 13, 0, 0, 0, 0, time.Local),
		},
		{
			// DaycareID: daycare[0].ID,
			SlotID:    slots[0].ID,
			SlotCount: 1,
			Date:      time.Date(2025, time.February, 14, 0, 0, 0, 0, time.Local),
		},
		{
			// DaycareID: daycare[0].ID,
			SlotID:    slots[0].ID,
			SlotCount: 1,
			Date:      time.Date(2025, time.February, 15, 0, 0, 0, 0, time.Local),
		},
		{
			// DaycareID: daycare[0].ID,
			SlotID:    slots[3].ID,
			SlotCount: 1,
			Date:      time.Date(2025, time.May, 26, 0, 0, 0, 0, time.Local),
		},
		{
			// DaycareID: daycare[0].ID,
			SlotID:    slots[3].ID,
			SlotCount: 1,
			Date:      time.Date(2025, time.May, 27, 0, 0, 0, 0, time.Local),
		},
		{
			// DaycareID: daycare[0].ID,
			SlotID:    slots[3].ID,
			SlotCount: 1,
			Date:      time.Date(2025, time.May, 30, 0, 0, 0, 0, time.Local),
		},
		{
			// DaycareID: daycare[0].ID,
			SlotID:    slots[3].ID,
			SlotCount: 1,
			Date:      time.Date(2025, time.May, 31, 0, 0, 0, 0, time.Local),
		},
		{
			// DaycareID: daycare[0].ID,
			SlotID:    slots[3].ID,
			SlotCount: 1,
			Date:      time.Date(2025, time.May, 31, 0, 0, 0, 0, time.Local),
		},
		{
			// DaycareID: daycare[0].ID,
			SlotID:    slots[3].ID,
			SlotCount: 1,
			Date:      time.Date(2025, time.June, 1, 0, 0, 0, 0, time.Local),
		},
		{
			// DaycareID: daycare[0].ID,
			SlotID:    slots[3].ID,
			SlotCount: 1,
			Date:      time.Date(2025, time.June, 1, 0, 0, 0, 0, time.Local),
		},
		{
			// DaycareID: daycare[0].ID,
			SlotID:    slots[3].ID,
			SlotCount: 1,
			Date:      time.Date(2025, time.June, 1, 0, 0, 0, 0, time.Local),
		},
		{
			// DaycareID: daycare[0].ID,
			SlotID:    slots[3].ID,
			SlotCount: 1,
			Date:      time.Date(2025, time.June, 1, 0, 0, 0, 0, time.Local),
		},
	}

	if err := db.Create(&bookedSlotDaily).Error; err != nil {
		return err
	}

	review := []model.Reviews{
		{
			DaycareID: daycare[0].ID, UserID: users[0].ID, Rate: 5, Description: "Great daycare!",
		},
		{
			DaycareID: daycare[1].ID, UserID: users[0].ID, Rate: 2, Description: "Great daycare!",
		},
		{
			DaycareID: daycare[1].ID, UserID: users[1].ID, Rate: 3, Description: "Great daycare!",
		},
	}

	if err := db.Create(&review).Error; err != nil {
		return err
	}

	// reduceSlots := model.ReduceSlots{
	// 	SlotID: slots[0].ID, ReducedCount: 2, TargetDate: time.Date(2025, time.February, 13, 0, 0, 0, 0, time.Local),
	// }

	// if err := db.Create(&reduceSlots).Error; err != nil {
	// 	return err
	// }

	thumbnails := []model.Thumbnail{
		{DaycareID: daycare[0].ID, ImageUrl: dummyImgUrl},
		{DaycareID: daycare[1].ID, ImageUrl: dummyImgUrl},
	}

	if err := db.Create(&thumbnails).Error; err != nil {
		return err
	}

	return nil
}
