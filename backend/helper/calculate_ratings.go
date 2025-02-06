package helper

import "github.com/BryanEgbert/skripsi/model"

func CalculateRatings(reviews []model.Reviews) (float64, int) {
	if len(reviews) == 0 {
		return 0, 0
	}

	var total int
	for _, r := range reviews {
		total += r.Rate
	}
	avg := float64(total) / float64(len(reviews))
	return avg, len(reviews)
}
