package main

import (
	"context"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"

	apputils "github.com/BryanEgbert/skripsi/app_utils"
	"github.com/BryanEgbert/skripsi/seeder"
	"github.com/BryanEgbert/skripsi/setup"
	"github.com/joho/godotenv"
	"github.com/robfig/cron"
	"golang.ngrok.com/ngrok"
	"golang.ngrok.com/ngrok/config"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func main() {
	ctx := context.Background()

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
		if err := db.Exec("TRUNCATE TABLE users, vet_specialties, user_vet_specialties, pet_daycares, pets, size_categories, roles, slots, booked_slots, thumbnails, pet_categories, reviews, refresh_tokens, daily_walks, daily_playtimes, reduce_slots, booked_slots_dailies, booked_slot_statuses, pricing_types RESTART IDENTITY CASCADE;").Error; err != nil {
			log.Fatalf("Truncate err: %v", err)
		}
		if err := seeder.SeedTable(db); err != nil {
			log.Fatal(err)
		}
	}

	apputils.UpdateBookSlotStatus(db)

	newCron := cron.New()

	go func() {
		log.Println("Running daily UpdateBookSlotStatus job...")
		newCron.AddFunc("@daily", func() {
			apputils.UpdateBookSlotStatus(db)
		})
		newCron.Start()
	}()
	defer newCron.Stop()

	if os.Getenv("USE_NGROK") == "1" {
		listener, err := ngrok.Listen(ctx,
			config.HTTPEndpoint(config.WithScheme(config.SchemeHTTP)),
			ngrok.WithAuthtokenFromEnv(),
		)

		if err != nil {
			log.Fatalf("ngrok.Listen err: %v", err)
		}

		log.Println("App URL", listener.URL())
		if err := http.Serve(listener, r); err != nil {
			log.Fatalf("Run err: %v", err)
		}
	} else {
		if err := r.Run(net.JoinHostPort(os.Getenv("HOST"), os.Getenv("PORT"))); err != nil {
			log.Fatalf("Run err: %v", err)
		}
	}
}
