const express = require('express');
const router = express.Router();
const orderController = require('../controllers/orderController');
const authMiddleware = require('../middleware/auth');

// Checkout - beli buku (protected)
router.post('/checkout', authMiddleware, orderController.checkout);

// Get my orders (protected)
router.get('/my-orders', authMiddleware, orderController.getMyOrders);

// Get order by order number (protected)
router.get('/:orderNumber', authMiddleware, orderController.getOrder);

module.exports = router;