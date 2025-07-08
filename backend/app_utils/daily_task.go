package apputils

import (
	"log"

	"github.com/BryanEgbert/skripsi/model"
	"gorm.io/gorm"
)

func UpdateBookSlotStatus(db *gorm.DB) {
	doneStatus := uint(4)
	ignoredStatus := uint(6)

	// var bookedSlots []model.BookedSlot
	if err := db.Debug().Model(model.BookedSlot{}).
		Where("status_id = ? AND end_date < NOW()", 2).Update("status_id", &doneStatus).
		Error; err != nil {
		log.Printf("[ERROR] updateBookSlotStatus err: %v", err)
		return
	}

	if err := db.Debug().Model(model.BookedSlot{}).
		Where("status_id = ? AND end_date < NOW()", 1).Update("status_id", &ignoredStatus).
		Error; err != nil {
		log.Printf("[ERROR] updateBookSlotStatus err: %v", err)
		return
	}

	var bookedSlots []model.BookedSlot
	var bookedSlotIds []uint

	if err := db.Debug().Where("status_id IN ?", []uint{doneStatus, ignoredStatus}).Find(&bookedSlots).Error; err != nil {
		log.Printf("[ERROR] updateBookSlotStatus err: %v", err)
		return
	}

	for _, val := range bookedSlots {
		bookedSlotIds = append(bookedSlotIds, val.ID)
	}

	if err := db.Debug().Unscoped().Where("slot_id IN ?", bookedSlotIds).Delete(&model.BookedSlotsDaily{}).Error; err != nil {
		log.Printf("Delete BookedSlotsDaily: %v", err)
		db.Rollback()
		return
	}
}
