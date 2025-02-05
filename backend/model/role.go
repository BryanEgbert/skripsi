package model

type Role struct {
	ID    uint   `gorm:"primarykey" json:"id"`
	Name  string `gorm:"unique;not null" json:"name"`
	Users []User `gorm:"foreignKey:RoleID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
}
