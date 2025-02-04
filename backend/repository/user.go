package repository

import (
	"database/sql"

	"github.com/BryanEgbert/skripsi/model"
	"github.com/nullism/bqb"
)

type UserRepository interface {
	GetUser(id int64) (*model.UserDTO, error)
	// GetUserCredential(id int64) (model.UserCredential, error)
}

type PostgresUserRepository struct {
	db *sql.DB
}

func NewMariaDBUserRepository(db *sql.DB) *PostgresUserRepository {
	return &PostgresUserRepository{
		db: db,
	}
}

func (r *PostgresUserRepository) GetUser(id int64) (*model.UserDTO, error) {
	var user model.UserDTO

	sql, params, err := bqb.New("SELECT id, name, email, roleId, createdAt FROM users").
		Space("WHERE id = ?;", id).
		ToPgsql()
	if err != nil {
		return nil, err
	}

	row := r.db.QueryRow(sql, params...)
	if err := row.Scan(&)
}
