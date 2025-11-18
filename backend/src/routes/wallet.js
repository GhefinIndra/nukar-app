const express = require('express');
const router = express.Router();
const walletController = require('../controllers/walletController');
const authMiddleware = require('../middleware/auth');

// Get balance (protected)
router.get('/balance', authMiddleware, walletController.getBalance);

// Get transaction history (protected)
router.get('/transactions', authMiddleware, walletController.getTransactions);

module.exports = router;