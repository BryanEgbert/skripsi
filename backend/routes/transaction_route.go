package routes

import (
	"github.com/BryanEgbert/skripsi/controller"
	"github.com/BryanEgbert/skripsi/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterTransactionRoute(r *gin.Engine, transactionController *controller.TransactionController) *gin.Engine {
	r.GET("/transaction", middleware.JWTAuth(), transactionController.GetTransactions)
	r.GET("/transaction/:id", middleware.JWTAuth(), transactionController.GetTransaction)

	return r
}
