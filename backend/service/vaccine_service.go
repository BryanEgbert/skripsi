package service

import (
	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type VaccineService interface {
	CreateVaccineRecords(userId uint, petId uint, req model.VaccineRecordRequest) (uint, error)
}

type VaccineServiceImpl struct {
	db *gorm.DB
}

func NewVaccineService(db *gorm.DB) *VaccineServiceImpl {
	return &VaccineServiceImpl{db: db}
}

func (s *VaccineServiceImpl) CreateVaccineRecords(userId uint, petId uint, req model.VaccineRecordRequest) (uint, error) {
	vaccineRecord := model.VaccineRecord {
		PetID: petId,
		DateAdministered: req.DateAdministered,
		NextDueDate: req.NextDueDate,
		ImageURL: req.VaccineRecordImageUrl,
	}

	if err := s.db.Debug().
		Clauses(clause.Returning{Columns: []clause.Column{{Name: "id"}}}).
		Create(&vaccineRecord).Error; err != nil {
		return 0, err
	}

	return vaccineRecord.ID, nil
}