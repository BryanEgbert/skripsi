package setup

import (
	"context"
	"fmt"
	"log"
	"os"
	"testing"

	firebase "firebase.google.com/go/v4"
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/routes"
	"github.com/BryanEgbert/skripsi/seeder"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"google.golang.org/api/option"
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
		&model.ChatImage{},
		&model.PricingType{},
	)

	if err := db.Exec("TRUNCATE TABLE users, vet_specialties, user_vet_specialties, pet_daycares, pets, size_categories, roles, slots, booked_slots, thumbnails, pet_categories, reviews, refresh_tokens, transactions, daily_walks, daily_playtimes, reduce_slots, booked_slots_dailies, pricing_types RESTART IDENTITY CASCADE;").Error; err != nil {
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
		&model.BookedSlotStatus{},
		&model.SavedAddress{},
		&model.ChatMessage{},
		&model.ChatImage{},
	)

	ctx := context.Background()
	r := gin.Default()
	opt := option.WithCredentialsFile("./skripsi-e8cfb-firebase-adminsdk-fbsvc-4d06e0c321.json")
	app, err := firebase.NewApp(ctx, nil, opt)
	if err != nil {
		log.Fatalf("error initializing app: %v\n", err)
		os.Exit(1)
	}

	client, err := app.Messaging(ctx)
	if err != nil {
		log.Fatalf("error getting Messaging client: %v\n", err)
		os.Exit(1)
	}

	userService := service.NewUserService(db)
	petService := service.NewPetService(db)
	vaccineRecordService := service.NewVaccineService(db)
	petDaycareService := service.NewPetDaycareService(db)

	userController := controller.NewUserController(userService, petService, vaccineRecordService, petDaycareService)

	authService := service.NewAuthService(db)
	authController := controller.NewAuthController(authService)

	petController := controller.NewPetController(petService, vaccineRecordService)

	slotService := service.NewSlotService(db)
	reviewService := service.NewReviewService(db)
	petDaycareController := controller.NewPetDaycareController(petDaycareService, petService, slotService, reviewService)

	categoryService := service.NewCategoryService(db)
	categoryController := controller.NewCategoryController(categoryService)

	vaccineRecordController := controller.NewVaccineRecordController(vaccineRecordService)

	transactionService := service.NewTransactionService(db)
	transactionController := controller.NewTransactionController(transactionService)

	slotController := controller.NewSlotController(slotService)

	chatService := service.NewChatService(db)
	chatController := controller.NewChatController(chatService, userService, client)

	imageService := service.NewImageService(db)
	imageController := controller.NewImageController(imageService)

	savedAddressService := service.NewSavedAddressService(db)
	savedAddressController := controller.NewSavedAddressController(savedAddressService)

	r.Static("/image", "./image")
	r = routes.RegisterUserRoute(r, userController)
	r = routes.RegisterAuthRoute(r, authController)
	r = routes.RegisterPetRoutes(r, petController, vaccineRecordController)
	r = routes.RegisterPetDaycareRoutes(r, petDaycareController)
	r = routes.RegisterCategoryRoutes(r, categoryController)
	r = routes.RegisterVaccineRecordRoute(r, vaccineRecordController)
	r = routes.RegisterTransactionRoute(r, transactionController)
	r = routes.RegisterSlotRoute(r, slotController)
	r = routes.RegisterChatRoute(r, chatController)
	r = routes.RegisterImageRoute(r, imageController)
	r = routes.RegisterSavedAddressRoute(r, savedAddressController)

	return r
}
