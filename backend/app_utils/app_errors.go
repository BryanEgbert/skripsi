package apputils

import "errors"

var ErrOnlyOnePet = errors.New("you must have at least one pet")
var ErrSlotFull = errors.New("slots are full in between the chosen date")
var ErrOnlyOneSlotDate = errors.New("invalid booking: this pet daycare charges per night. a minimum of one night stay is required. please adjust your booking dates")
var ErrPetAlreadyBooked = errors.New("one or more pets are already booked in an active slot")
