const db = require('../config/database');
const bcrypt = require('bcryptjs');

class User {
  // Create new user dengan Phone + PIN
  static async create(userData) {
    try {
      const { mobilePhone, fullName, pin, referralCode } = userData;
      
      // Hash PIN (6 digit)
      const hashedPin = await bcrypt.hash(pin, 10);
      
      const [result] = await db.query(
        'INSERT INTO users (mobile_phone, full_name, pin, referral_code) VALUES (?, ?, ?, ?)',
        [mobilePhone, fullName, hashedPin, referralCode || null]
      );
      
      return result.insertId;
    } catch (error) {
      throw error;
    }
  }

  // Find user by phone number
  static async findByPhone(mobilePhone) {
    try {
      const [rows] = await db.query(
        'SELECT * FROM users WHERE mobile_phone = ?',
        [mobilePhone]
      );
      return rows[0] || null;
    } catch (error) {
      throw error;
    }
  }

  // Find user by ID
  static async findById(id) {
    try {
      const [rows] = await db.query(
        'SELECT id, mobile_phone, full_name, referral_code, created_at FROM users WHERE id = ?',
        [id]
      );
      return rows[0] || null;
    } catch (error) {
      throw error;
    }
  }

  // Verify PIN
  static async verifyPin(plainPin, hashedPin) {
    return await bcrypt.compare(plainPin, hashedPin);
  }
}

module.exports = User;