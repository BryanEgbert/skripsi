package setup

import (
	"fmt"
	"os"
	"testing"

	"github.com/BryanEgbert/skripsi/controller"
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

	if _, err := os.Stat("./image"); os.IsNotExist(err) {
		if err := os.Mkdir("./image", os.ModePerm); err != nil {
			t.Fatalf("Mkdir err: %s", err.Error())
		}
	}

	dbURL := fmt.Sprintf("postgres://%s:%s@localhost:%s/%s",
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASS"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_NAME"),
	)

	db, err := gorm.Open(postgres.Open(dbURL), &gorm.Config{})
	if err != nil {
		t.Fatal(err)
	}

	if err := db.Exec("TRUNCATE TABLE users, vet_specialties, user_vet_specialties, pet_daycares, pets, size_categories, roles, slots, booked_slots, thumbnails, species, reviews, refresh_tokens, transactions, daily_walks, daily_playtimes, reduce_slots RESTART IDENTITY CASCADE;").Error; err != nil {
		t.Fatalf("Truncate err: %v", err)
	}

	if err := seeder.SeedTable(db); err != nil {
		t.Fatalf("Seeder err: %v", err)
	}

	return db
}

func Setup(db *gorm.DB) *gin.Engine {
	db.AutoMigrate(
		&model.User{},
		&model.VetSpecialty{},
		&model.PetDaycare{},
		&model.Pet{},
		&model.Slots{},
		&model.BookedSlot{},
		&model.SizeCategory{},
		&model.Thumbnail{},
		&model.Species{},
		&model.Role{},
		&model.Reviews{},
		&model.RefreshToken{},
		&model.Transaction{},
		&model.DailyWalks{},
		&model.DailyPlaytime{},
		&model.ReduceSlots{},
	)

	r := gin.Default()

	userService := service.NewUserService(db)
	userController := controller.NewUserController(userService)

	authService := service.NewAuthService(db)
	authController := controller.NewAuthController(authService)

	petService := service.NewPetService(db)
	petController := controller.NewPetController(petService)

	petDaycareService := service.NewPetDaycareService(db)
	slotService := service.NewSlotService(db)
	petDaycareController := controller.NewPetDaycareController(petDaycareService, slotService)

	r.Static("/assets", "./image")
	r = routes.RegisterUserRoute(r, userController)
	r = routes.RegisterAuthRoute(r, authController)
	r = routes.RegisterPetRoutes(r, petController)
	r = routes.RegisterPetDaycareRoutes(r, petDaycareController)

	return r
}
