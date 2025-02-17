package controller

import (
	"net/http"
	"strconv"

	"github.com/BryanEgbert/skripsi/service"
	"github.com/gin-gonic/gin"
)

type TransactionController struct {
	transactionService service.TransactionService
}

func NewTransactionController(transactionService service.TransactionService) *TransactionController {
	return &TransactionController{transactionService}
}

func (tc *TransactionController) GetTransactiions(c *gin.Context) {
	userIDRaw, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	userID, ok := userIDRaw.(uint)
	if !ok {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	lastID, err := strconv.ParseUint(c.DefaultQuery("last-id", "0"), 10, 64)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error(), "details": err.Error()})
		return
	}

	pageSize, err := strconv.Atoi(c.DefaultQuery("size", "10"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error(), "details": err.Error()})
		return
	}

	out, err := tc.transactionService.GetTransactions(userID, uint(lastID), pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Cannot get transactions", "details": err.Error()})
		return
	}

	c.JSON(http.StatusOK, out)
}
