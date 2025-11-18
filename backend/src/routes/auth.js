const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// Register dengan Phone + PIN
router.post('/register', authController.register);

// Login dengan Phone + PIN
router.post('/login', authController.login);

module.exports = router;