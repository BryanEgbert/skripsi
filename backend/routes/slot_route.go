package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterSlotRoute(r *gin.Engine, slotController *controller.SlotController) *gin.Engine {
	slotGroup := r.Group("/slots")

	slotGroup.PATCH("/:id/accept", middleware.JWTAuth(), slotController.AcceptBookedSlot)
	slotGroup.PATCH("/:id/reject", middleware.JWTAuth(), slotController.RejectBookedSlot)
	slotGroup.PATCH("/:id/cancel", middleware.JWTAuth(), slotController.CancelBookedSlot)

	return r
}
