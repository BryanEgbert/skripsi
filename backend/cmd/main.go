package main

import (
	"fmt"
	"log"
	"os"

	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/model"
	"github.com/BryanEgbert/skripsi/routes"
	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	if _, err := os.Stat("./image"); os.IsNotExist(err) {
		if err := os.Mkdir("./image", os.ModePerm); err != nil {
			log.Fatalf("Mkdir err: %s", err.Error())
		}
	}

	r := gin.Default()
	dbURL := fmt.Sprintf("postgres://%s:%s@localhost:%s/%s",
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASS"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_NAME"),
	)

	db, err := gorm.Open(postgres.Open(dbURL), &gorm.Config{})
	if err != nil {
		log.Fatal(err)
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
		&model.Species{},
		&model.Role{},
		&model.Reviews{},
		&model.RefreshToken{},
	)

	userService := service.NewUserService(db)
	userController := controller.NewUserController(userService)

	authService := service.NewAuthService(db)
	authController := controller.NewAuthController(authService)

	petService := service.NewPetService(db)
	petController := controller.NewPetController(petService)

	petDaycareService := service.NewPetDaycareService(db)
	petDaycareController := controller.NewPetDaycareController(petDaycareService)

	r.Static("/assets", "./image")
	r = routes.RegisterUserRoute(r, userController)
	r = routes.RegisterAuthRoute(r, authController)
	r = routes.RegisterPetRoutes(r, petController)
	r = routes.RegisterPetDaycareRoutes(r, petDaycareController)

	r.Run()
}
