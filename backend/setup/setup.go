package setup

import (
	"fmt"
	"log"
	"os"
	"testing"

	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/routes"
	"github.com/BryanEgbert/skripsi/seeder"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func SetupTest(t *testing.T) *gorm.DB {
	err := godotenv.Load("../.env")
	if err != nil {
		t.Fatal("Error loading .env file")
	}

	if err := helper.CopyFileIfNotExists("test_image/dog.jpeg", "image/dog.jpeg"); err != nil {
		t.Fatalf("copy err: %v", err)
	}

	if err := helper.CopyFileIfNotExists("test_image/test.jpeg", "image/test.jpeg"); err != nil {
		t.Fatalf("copy err: %v", err)
	}

	if err := helper.CopyFileIfNotExists("test_image/user_test.png", "image/user_test.png"); err != nil {
		t.Fatalf("copy err: %v", err)
	}

	dbURL := fmt.Sprintf("postgres://%s:%s@localhost:%s/%s",
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASS"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_NAME"),
	)

	db, err := gorm.Open(postgres.Open(dbURL))
	if err != nil {
		t.Fatal(err)
	}

	db.AutoMigrate(
		&model.User{},
		&model.VetSpecialty{},
		&model.PetDaycare{},
		&model.Pet{},
		&model.Slots{},
		&model.BookedSlot{},
		&model.SizeCategory{},
		&model.Thumbnail{},
		&model.PetCategory{},
		&model.Role{},
		&model.Reviews{},
		&model.RefreshToken{},
		&model.Transaction{},
		&model.DailyWalks{},
		&model.DailyPlaytime{},
		&model.ReduceSlots{},
		&model.BookedSlotsDaily{},
	)

	if err := db.Exec("TRUNCATE TABLE users, vet_specialties, user_vet_specialties, pet_daycares, pets, size_categories, roles, slots, booked_slots, thumbnails, pet_categories, reviews, refresh_tokens, transactions, daily_walks, daily_playtimes, reduce_slots, booked_slots_dailies RESTART IDENTITY CASCADE;").Error; err != nil {
		t.Fatalf("Truncate err: %v", err)
	}

	if err := seeder.SeedTable(db); err != nil {
		t.Fatalf("Seeder err: %v", err)
	}

	return db
}

func Setup(db *gorm.DB) *gin.Engine {
	if _, err := os.Stat("./image"); os.IsNotExist(err) {
		if err := os.Mkdir("./image", os.ModePerm); err != nil {
			log.Fatalf("Mkdir err: %s", err.Error())
		}
	}

	db.AutoMigrate(
		&model.User{},
		&model.VetSpecialty{},
		&model.PetDaycare{},
		&model.Pet{},
		&model.Slots{},
		&model.BookedSlot{},
		&model.SizeCategory{},
		&model.Thumbnail{},
		&model.PetCategory{},
		&model.Role{},
		&model.Reviews{},
		&model.RefreshToken{},
		&model.Transaction{},
		&model.DailyWalks{},
		&model.DailyPlaytime{},
		&model.ReduceSlots{},
		&model.BookedSlotsDaily{},
		&model.VaccineRecord{},
	)

	r := gin.Default()

	userService := service.NewUserService(db)
	petService := service.NewPetService(db)
	vaccineRecordService := service.NewVaccineService(db)
	petDaycareService := service.NewPetDaycareService(db)

	userController := controller.NewUserController(userService, petService, vaccineRecordService, petDaycareService)

	authService := service.NewAuthService(db)
	authController := controller.NewAuthController(authService)

	petController := controller.NewPetController(petService)

	slotService := service.NewSlotService(db)
	reviewService := service.NewReviewService(db)
	petDaycareController := controller.NewPetDaycareController(petDaycareService, petService, slotService, reviewService)

	categoryService := service.NewCategoryService(db)
	categoryController := controller.NewCategoryController(categoryService)

	vaccineRecordController := controller.NewVaccineRecordController(vaccineRecordService)

	r.Static("/image", "./image")
	r = routes.RegisterUserRoute(r, userController)
	r = routes.RegisterAuthRoute(r, authController)
	r = routes.RegisterPetRoutes(r, petController)
	r = routes.RegisterPetDaycareRoutes(r, petDaycareController)
	r = routes.RegisterCategoryRoutes(r, categoryController)
	r = routes.RegisterVaccineRecordRoute(r, vaccineRecordController)

	return r
}
