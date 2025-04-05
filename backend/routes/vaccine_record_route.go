package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterVaccineRecordRoute(r *gin.Engine, vaccineRecordController *controller.VaccineRecordController) *gin.Engine {
	r.GET("/vaccination-record/:petId", middleware.JWTAuth(), vaccineRecordController.GetVaccineRecords)
	r.POST("/vaccination-record/:petId", middleware.JWTAuth(), vaccineRecordController.CreateVaccineRecords)
	r.DELETE("/vaccination-record/:vaccineRecordId", middleware.JWTAuth(), vaccineRecordController.DeleteVaccineRecords)

	return r
}
