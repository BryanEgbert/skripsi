package model

import (
	"database/sql/driver"
	"errors"
	"fmt"
	"mime/multipart"
	"time"

	"gorm.io/gorm"
	"gorm.io/gorm/schema"
)

type CustomTime struct {
	time.Time
}

func (CustomTime) GormDataType() string {
	return "time"
}

func (CustomTime) GormDBDataType(db *gorm.DB, field *schema.Field) string {
	return "time"
}

func (c CustomTime) Value() (driver.Value, error) {
	return c.Time.Format("1504"), nil
}

func (c *CustomTime) Scan(value interface{}) error {
	valueStr, ok := value.(string)
	if !ok {
		return errors.New(fmt.Sprintf("Failed to parse value: %v", value))
	}

	layout := "15:04:05"
	parsedTime, err := time.Parse(layout, valueStr)
	if err != nil {
		return errors.New(fmt.Sprintf("Error parsing time: %v", err))
	}

	c.Time = parsedTime

	return nil
}

type PetDaycare struct {
	gorm.Model
	Name              string     `gorm:"not null"`
	Address           string     `gorm:"not null"`
	Locality          string     `gorm:"not null"`
	Location          string     `gorm:"not null"`
	Latitude          float64    `gorm:"not null"`
	Longitude         float64    `gorm:"not null"`
	OpeningHour       CustomTime `gorm:"not null;type:time"`
	ClosingHour       CustomTime `gorm:"not null;type:time"`
	Description       string
	HasPickupService  bool    `gorm:"default:0"`
	MustBeVaccinated  bool    `gorm:"default:0"`
	FoodProvided      bool    `gorm:"default:0"`
	GroomingAvailable bool    `gorm:"default:0"`
	BookedNum         int64   `gorm:"default:0"`
	DailyWalksID      uint    `gorm:"not null"`
	DailyPlaytimeID   uint    `gorm:"not null"`
	OwnerID           uint    `gorm:"unique;not null"` // One-to-One with User
	Distance          float64 `gorm:"->;-:migration"`
	FoodBrand         string
	CreatedAt         time.Time
	UpdatedAt         *time.Time

	Owner         User          `gorm:"foreignKey:OwnerID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	DailyWalks    DailyWalks    `gorm:"foreignKey:DailyWalksID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;" json:"daily_walks"`
	DailyPlaytime DailyPlaytime `gorm:"foreignKey:DailyPlaytimeID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;" json:"daily_playtime"`
	Reviews       []Reviews     `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many
	Slots         []Slots       `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many
	BookedSlots   []BookedSlot  `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many
	Thumbnails    []Thumbnail   `gorm:"foreignKey:DaycareID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"` // One-to-Many
}

type PetDaycareDTO struct {
	ID                uint       `json:"id"`
	Name              string     `json:"name"`
	Address           string     `json:"address"`
	Locality          string     `json:"locality"`
	Location          string     `json:"location"`
	Description       string     `json:"description"`
	OpeningHour       string     `json:"openingHour"`
	ClosingHour       string     `json:"closingHour"`
	Price             float64    `json:"price"`
	PricingType       string     `json:"pricingType"`
	BookedNum         int64      `json:"bookedNum"`
	OwnerID           uint       `json:"ownerId"`
	HasPickupService  bool       `json:"hasPickupService"`
	MustBeVaccinated  bool       `json:"mustBeVaccinated"`
	GroomingAvailable bool       `json:"groomingAvailable"`
	FoodProvided      bool       `json:"foodProvided"`
	FoodBrand         string     `json:"foodBrand"`
	CreatedAt         time.Time  `json:"createdAt"`
	UpdatedAt         *time.Time `json:"updatedAt"`
	DailyWalksID      uint       `json:"dailyWalksId"`
	DailyPlaytimeID   uint       `json:"dailyPlaytimeId"`
	ThumbnailURLs     []string   `json:"thumbnailUrls"`
}

// CreatePetDaycareRequest represents the request payload
type CreatePetDaycareRequest struct {
	PetDaycareName    string                  `form:"petDaycareName" binding:"required"`
	Address           string                  `form:"address" binding:"required"`
	Locality          string                  `form:"locality" binding:"required"`
	Location          string                  `form:"location" binding:"required"`
	Latitude          float64                 `form:"latitude" binding:"required"`
	Longitude         float64                 `form:"longitude" binding:"required"`
	Description       string                  `form:"description"`
	OpeningHour       string                  `form:"openingHour"`
	ClosingHour       string                  `form:"closingHour"`
	Price             []float64               `form:"price[]"`
	PricingType       []string                `form:"pricingType[]"`
	HasPickupService  bool                    `form:"hasPickupService"`
	MustBeVaccinated  bool                    `form:"mustBeVaccinated"`
	GroomingAvailable bool                    `form:"groomingAvailable"`
	FoodProvided      bool                    `form:"foodProvided"`
	FoodBrand         string                  `form:"foodBrand"`
	DailyWalksID      uint                    `form:"dailyWalksId" binding:"required"`
	DailyPlaytimeID   uint                    `form:"dailyPlaytimeId" binding:"required"`
	Thumbnails        []*multipart.FileHeader `form:"thumbnails[]" binding:"required"`
	PetCategoryID     []uint                  `form:"petCategoryId[]" binding:"required"`
	MaxNumber         []int                   `form:"maxNumber[]" binding:"required"`
	ThumbnailURLs     []string
}

type UpdatePetDaycareRequest struct {
	PetDaycareName    string                  `form:"petDaycareName" binding:"required"`
	Address           string                  `form:"address" binding:"required"`
	Locality          string                  `form:"locality" binding:"required"`
	Location          string                  `form:"location" binding:"required"`
	Latitude          float64                 `form:"latitude" binding:"required"`
	Longitude         float64                 `form:"longitude" binding:"required"`
	Description       string                  `form:"description"`
	OpeningHour       string                  `form:"openingHour"`
	ClosingHour       string                  `form:"closingHour"`
	Price             []float64               `form:"price[]"`
	PricingType       []string                `form:"pricingType[]"`
	HasPickupService  bool                    `form:"hasPickupService"`
	MustBeVaccinated  bool                    `form:"mustBeVaccinated"`
	GroomingAvailable bool                    `form:"groomingAvailable"`
	FoodProvided      bool                    `form:"foodProvided"`
	FoodBrand         string                  `form:"foodBrand"`
	DailyWalksID      uint                    `form:"dailyWalksId" binding:"required"`
	DailyPlaytimeID   uint                    `form:"dailyPlaytimeId" binding:"required"`
	ThumbnailIndex    []int                   `form:"thumbnailIndex[]"`
	Thumbnails        []*multipart.FileHeader `form:"thumbnails[]"`
	PetCategoryID     []uint                  `form:"petCategoryId[]" binding:"required"`
	MaxNumber         []int                   `form:"maxNumber[]" binding:"required"`
	ThumbnailURLs     []string
}

type GetPetDaycaresRequest struct {
	Latitude         *float64
	Longitude        *float64
	MinDistance      float64
	MaxDistance      float64
	Facilities       []string
	MustBeVaccinated *bool
	DailyWalks       uint
	DailyPlaytime    uint
	MinPrice         float64
	MaxPrice         float64
	PricingType      *string
}

type GetPetDaycareDetailResponse struct {
	ID                uint           `json:"id"`
	Name              string         `json:"name"`
	Address           string         `json:"address"`
	Distance          float64        `json:"distance"`
	Locality          string         `json:"locality"`
	Location          string         `json:"location"`
	Latitude          float64        `json:"latitude"`
	Longitude         float64        `json:"longitude"`
	OpeningHour       string         `json:"openingHour"`
	ClosingHour       string         `json:"closingHour"`
	Pricings          []PriceDetails `json:"pricings"`
	Description       string         `json:"description"`
	BookedNum         int64          `json:"bookedNum"`
	AverageRating     float64        `json:"averageRating"`
	RatingCount       int            `json:"ratingCount"`
	HasPickupService  bool           `json:"hasPickupService"`
	MustBeVaccinated  bool           `json:"mustBeVaccinated"`
	GroomingAvailable bool           `json:"groomingAvailable"`
	FoodProvided      bool           `json:"foodProvided"`
	FoodBrand         string         `json:"foodBrand"`
	CreatedAt         string         `json:"createdAt"`
	Owner             UserDTO        `json:"owner"`
	DailyWalks        DailyWalks     `json:"dailyWalks"`
	DailyPlaytime     DailyPlaytime  `json:"dailyPlaytime"`
	ThumbnailURLs     []string       `json:"thumbnailUrls"`
}

type GetPetDaycaresResponse struct {
	ID            uint           `json:"id"`
	Name          string         `json:"name"`
	Distance      float64        `json:"distance"`
	Address       string         `json:"address"`
	Locality      string         `json:"locality"`
	AverageRating float64        `json:"averageRating"`
	RatingCount   int            `json:"ratingCount"`
	BookedNum     int64          `json:"bookedNum"`
	Prices        []PriceDetails `json:"prices"`
	Thumbnail     string         `json:"thumbnail"`
}

type PriceDetails struct {
	PetCategory PetCategoryDTO `json:"petCategory"`
	Price       float64        `json:"price"`
	PricingType string         `json:"pricingType"`
}

type BookSlotsRequest struct {
	StartDate time.Time `json:"startDate"`
	EndDate   time.Time `json:"endDate"`
	PetID     uint      `json:"petId"`
	DaycareID uint      `json:"daycareID"`
}
