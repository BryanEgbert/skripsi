package main

import (
	"fmt"
	"log"
	"os"

	"github.com/BryanEgbert/skripsi/seeder"
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

	if os.Getenv("SEED_TABLE") == "1" {
		if err := db.Exec("TRUNCATE TABLE users, vet_specialties, user_vet_specialties, pet_daycares, pets, size_categories, roles, slots, booked_slots, thumbnails, pet_categories, reviews, refresh_tokens, transactions, daily_walks, daily_playtimes, reduce_slots, booked_slots_dailies, booked_slot_statuses RESTART IDENTITY CASCADE;").Error; err != nil {
			log.Fatalf("Truncate err: %v", err)
		}
		if err := seeder.SeedTable(db); err != nil {
			log.Fatal(err)
		}
	}

	r.Run()
}
