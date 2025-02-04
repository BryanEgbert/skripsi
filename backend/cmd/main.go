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
	)

	userService := service.NewUserService(db)
	userController := controller.NewUserController(userService)

	r = routes.RegisterUserRoute(r, userController)
	r.Run()
}
