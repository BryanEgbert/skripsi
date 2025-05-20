package service

import (
	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

type SavedAddressService interface {
	GetSavedAddress(id uint, page int, pageSize int) ([]model.SavedAddressDTO, error)
	AddSavedAddress(userID uint, req model.CreateSavedAddress) error
	DeleteSavedAddress(addressID uint) error
	EditSavedAddress(addressID uint, req model.CreateSavedAddress) error
}

type SavedAddressServiceImpl struct {
	db *gorm.DB
}

func NewSavedAddressService(db *gorm.DB) *SavedAddressServiceImpl {
	return &SavedAddressServiceImpl{db: db}
}

func (s *SavedAddressServiceImpl) EditSavedAddress(addressID uint, req model.CreateSavedAddress) error {
	var savedAddress model.SavedAddress

	if err := s.db.First(&savedAddress, addressID).Error; err != nil {
		return err
	}

	savedAddress.Address = req.Address
	savedAddress.Name = req.Name
	savedAddress.Latitude = req.Latitude
	savedAddress.Longitude = req.Longitude
	savedAddress.Notes = req.Notes

	if err := s.db.Save(&savedAddress).Error; err != nil {
		return err
	}

	return nil
}

func (s *SavedAddressServiceImpl) DeleteSavedAddress(addressID uint) error {
	if err := s.db.Delete(&model.SavedAddress{}, addressID).Error; err != nil {
		return err
	}

	return nil
}

func (s *SavedAddressServiceImpl) AddSavedAddress(userID uint, req model.CreateSavedAddress) error {
	savedAddress := model.SavedAddress{
		Name:      req.Name,
		UserID:    userID,
		Address:   req.Address,
		Latitude:  req.Latitude,
		Longitude: req.Longitude,
		Notes:     req.Notes,
	}

	if err := s.db.Create(&savedAddress).Error; err != nil {
		return err
	}

	return nil
}

func (s *SavedAddressServiceImpl) GetSavedAddress(id uint, page int, pageSize int) ([]model.SavedAddressDTO, error) {
	var savedAddresses []model.SavedAddress
	if err := s.db.
		Model(&model.SavedAddress{UserID: id}).
		Offset(pageSize * (page - 1)).
		Limit(pageSize).
		Find(&savedAddresses).Error; err != nil {
		return nil, err
	}

	out := helper.ConvertSavedAddressesToDTO(savedAddresses)

	return out, nil
}
