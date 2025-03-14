package model

type PetCategory struct {
	ID   uint   `gorm:"primarykey" json:"id"`
	Name string `gorm:"unique;not null" json:"name"`
	SizeCategoryID *uint
	SizeCategory SizeCategory `gorm:"foreignKey:SizeCategoryID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

type PetCategoryDTO struct {
	ID uint `json:"id"`
	Name string `json:"name"`
	SizeCategory SizeCategory `json:"sizeCategory"`
}