const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/paymentController');
const authMiddleware = require('../middleware/auth');

// Initiate topup (protected)
router.post('/topup', authMiddleware, paymentController.initiateTopup);

// Callback from Finpay for TOPUP (public - no auth)
router.post('/callback', paymentController.handleCallback);

// Callback from Finpay for ORDER (public - no auth) ← TAMBAHKAN INI
router.post('/callback-order', paymentController.handleOrderCallback);

module.exports = router;