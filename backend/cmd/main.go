package main

import (
	"fmt"
	"log"
	"os"

	"github.com/BryanEgbert/skripsi/setup"
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

	r := setup.Setup(db)
	r.Run()
}
