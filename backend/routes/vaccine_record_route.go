package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterVaccineRecordRoute(r *gin.Engine, vaccineRecordController *controller.VaccineRecordController) *gin.Engine {
	r.GET("/vaccine-record/:petId", middleware.JWTAuth(), vaccineRecordController.GetVaccineRecords)

	return r
}
