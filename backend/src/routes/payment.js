const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/paymentController');
const authMiddleware = require('../middleware/auth');

router.post('/topup', authMiddleware, paymentController.initiateTopup);
router.post('/callback', paymentController.handleCallback);

module.exports = router;
