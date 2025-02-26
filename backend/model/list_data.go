package model

type ListData[T any] struct {
	Data []T `json:"data"`
}