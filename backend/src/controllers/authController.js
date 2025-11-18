const User = require('../models/User');
const Wallet = require('../models/Wallet');
const { generateToken } = require('../config/jwt');
const { successResponse, errorResponse } = require('../utils/helpers');

// Register user + create wallet
exports.register = async (req, res) => {
  try {
    const { email, password, firstName, lastName, mobilePhone } = req.body;
    
    // Validasi input
    if (!email || !password || !firstName || !lastName || !mobilePhone) {
      return errorResponse(res, 'All fields are required', 400);
    }
    
    // Cek apakah email sudah terdaftar
    const existingUser = await User.findByEmail(email);
    if (existingUser) {
      return errorResponse(res, 'Email already registered', 400);
    }
    
    // Create user
    const userId = await User.create({
      email,
      password,
      firstName,
      lastName,
      mobilePhone
    });
    
    // Create wallet untuk user
    const walletId = await Wallet.create(userId);
    
    // Generate token
    const token = generateToken({ userId, email });
    
    // Get user data
    const user = await User.findById(userId);
    const wallet = await Wallet.findById(walletId);
    
    return successResponse(res, {
      user: {
        id: user.id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        mobilePhone: user.mobile_phone
      },
      wallet: {
        id: wallet.id,
        balance: wallet.balance
      },
      token
    }, 'Registration successful', 201);
    
  } catch (error) {
    console.error('Register error:', error);
    return errorResponse(res, 'Registration failed', 500, error.message);
  }
};

// Login
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    
    // Validasi input
    if (!email || !password) {
      return errorResponse(res, 'Email and password are required', 400);
    }
    
    // Find user
    const user = await User.findByEmail(email);
    if (!user) {
      return errorResponse(res, 'Invalid credentials', 401);
    }
    
    // Verify password
    const isValidPassword = await User.verifyPassword(password, user.password);
    if (!isValidPassword) {
      return errorResponse(res, 'Invalid credentials', 401);
    }
    
    // Get wallet
    const wallet = await Wallet.findByUserId(user.id);
    
    // Generate token
    const token = generateToken({ userId: user.id, email: user.email });
    
    return successResponse(res, {
      user: {
        id: user.id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        mobilePhone: user.mobile_phone
      },
      wallet: {
        id: wallet.id,
        balance: wallet.balance
      },
      token
    }, 'Login successful');
    
  } catch (error) {
    console.error('Login error:', error);
    return errorResponse(res, 'Login failed', 500, error.message);
  }
};