const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');

// Get all products (public - no auth)
router.get('/', productController.getAllProducts);

// Get categories (public - no auth)
router.get('/categories', productController.getCategories);

// Get product by ID (public - no auth)
router.get('/:id', productController.getProductById);

module.exports = router;