package service

import (
	"os"

	"github.com/BryanEgbert/skripsi/helper"
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type VaccineService interface {
	GetVaccineRecord(id uint) (*model.VaccineRecordDTO, error)
	GetVaccineRecords(petId uint, page int, limit int) (*[]model.VaccineRecordDTO, error)
	CreateVaccineRecords(petId uint, req model.VaccineRecordRequest) (uint, error)
	UpdateVaccineRecord(id uint, req model.VaccineRecordRequest) error
	DeleteVaccineRecords(vaccineRecordId uint) error
}

type VaccineServiceImpl struct {
	db *gorm.DB
}

func NewVaccineService(db *gorm.DB) *VaccineServiceImpl {
	return &VaccineServiceImpl{db: db}
}

func (s *VaccineServiceImpl) GetVaccineRecord(id uint) (*model.VaccineRecordDTO, error) {
	var record model.VaccineRecord
	err := s.db.First(&record, id).Error
	if err != nil {
		return nil, err
	}

	dto := helper.ConvertVaccineRecordToDTO(record)

	return &dto, nil
}

func (s *VaccineServiceImpl) UpdateVaccineRecord(id uint, req model.VaccineRecordRequest) error {
	var record model.VaccineRecord
	err := s.db.First(&record, id).Error
	if err != nil {
		return err
	}

	os.Remove(helper.GetFilePath(record.ImageURL))

	record.DateAdministered = req.DateAdministered
	record.NextDueDate = req.NextDueDate
	record.ImageURL = req.VaccineRecordImageUrl

	if err := s.db.Save(&record).Error; err != nil {
		return err
	}

	return nil
}

func (s *VaccineServiceImpl) GetVaccineRecords(petId uint, page int, limit int) (*[]model.VaccineRecordDTO, error) {
	var records []model.VaccineRecord
	if err := s.db.
		Where("pet_id = ?", petId).
		Find(&records).
		Offset((page - 1) * limit).
		Limit(limit).Error; err != nil {
		return nil, err
	}

	dto := helper.ConvertVaccineRecordsToDTO(records)

	return &dto, nil
}

func (s *VaccineServiceImpl) CreateVaccineRecords(petId uint, req model.VaccineRecordRequest) (uint, error) {
	vaccineRecord := model.VaccineRecord{
		PetID:            petId,
		DateAdministered: req.DateAdministered,
		NextDueDate:      req.NextDueDate,
		ImageURL:         req.VaccineRecordImageUrl,
	}

	if err := s.db.Debug().
		Clauses(clause.Returning{Columns: []clause.Column{{Name: "id"}}}).
		Create(&vaccineRecord).Error; err != nil {
		return 0, err
	}

	return vaccineRecord.ID, nil
}

func (s *VaccineServiceImpl) DeleteVaccineRecords(vaccineRecordId uint) error {
	var vaccineRecord model.VaccineRecord
	if err := s.db.First(&vaccineRecord, vaccineRecordId).Error; err != nil {
		return err
	}

	os.Remove(helper.GetFilePath(vaccineRecord.ImageURL))

	if err := s.db.Unscoped().Delete(&vaccineRecord).Error; err != nil {
		return err
	}

	return nil
}
