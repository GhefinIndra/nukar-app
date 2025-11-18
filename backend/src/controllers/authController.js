const User = require('../models/User');
const Wallet = require('../models/Wallet');
const { generateToken } = require('../config/jwt');
const { successResponse, errorResponse } = require('../utils/helpers');

// Register dengan Phone + PIN
exports.register = async (req, res) => {
  try {
    const { mobilePhone, fullName, pin, referralCode } = req.body;
    
    // Validasi input
    if (!mobilePhone || !fullName || !pin) {
      return errorResponse(res, 'Phone number, full name, and PIN are required', 400);
    }
    
    // Validasi PIN (harus 6 digit)
    if (pin.length !== 6 || !/^\d+$/.test(pin)) {
      return errorResponse(res, 'PIN must be exactly 6 digits', 400);
    }
    
    // Validasi phone number (minimal 9 karakter)
    if (mobilePhone.length < 9) {
      return errorResponse(res, 'Phone number must be at least 9 characters', 400);
    }
    
    // Cek apakah phone sudah terdaftar
    const existingUser = await User.findByPhone(mobilePhone);
    if (existingUser) {
      return errorResponse(res, 'Phone number already registered', 400);
    }
    
    // Create user
    const userId = await User.create({
      mobilePhone,
      fullName,
      pin,
      referralCode
    });
    
    // Create wallet untuk user
    const walletId = await Wallet.create(userId);
    
    // Generate token
    const token = generateToken({ userId, mobilePhone });
    
    // Get user data
    const user = await User.findById(userId);
    const wallet = await Wallet.findById(walletId);
    
    return successResponse(res, {
      user: {
        id: user.id,
        mobilePhone: user.mobile_phone,
        fullName: user.full_name,
        referralCode: user.referral_code
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

// Login dengan Phone + PIN
exports.login = async (req, res) => {
  try {
    const { mobilePhone, pin } = req.body;
    
    // Validasi input
    if (!mobilePhone || !pin) {
      return errorResponse(res, 'Phone number and PIN are required', 400);
    }
    
    // Find user
    const user = await User.findByPhone(mobilePhone);
    if (!user) {
      return errorResponse(res, 'Invalid phone number or PIN', 401);
    }
    
    // Verify PIN
    const isValidPin = await User.verifyPin(pin, user.pin);
    if (!isValidPin) {
      return errorResponse(res, 'Invalid phone number or PIN', 401);
    }
    
    // Get wallet
    const wallet = await Wallet.findByUserId(user.id);
    
    // Generate token
    const token = generateToken({ userId: user.id, mobilePhone: user.mobile_phone });
    
    return successResponse(res, {
      user: {
        id: user.id,
        mobilePhone: user.mobile_phone,
        fullName: user.full_name,
        referralCode: user.referral_code
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