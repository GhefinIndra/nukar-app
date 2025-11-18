const db = require('../config/database');

class Wallet {
  // Create wallet for user
  static async create(userId) {
    try {
      const [result] = await db.query(
        'INSERT INTO wallets (user_id, balance) VALUES (?, 0.00)',
        [userId]
      );
      
      return result.insertId;
    } catch (error) {
      throw error;
    }
  }

  // Get wallet by user ID
  static async findByUserId(userId) {
    try {
      const [rows] = await db.query('SELECT * FROM wallets WHERE user_id = ?', [userId]);
      return rows[0] || null;
    } catch (error) {
      throw error;
    }
  }

  // Get wallet by ID
  static async findById(walletId) {
    try {
      const [rows] = await db.query('SELECT * FROM wallets WHERE id = ?', [walletId]);
      return rows[0] || null;
    } catch (error) {
      throw error;
    }
  }

  // Update balance
  static async updateBalance(walletId, amount) {
    try {
      const [result] = await db.query(
        'UPDATE wallets SET balance = balance + ? WHERE id = ?',
        [amount, walletId]
      );
      
      return result.affectedRows > 0;
    } catch (error) {
      throw error;
    }
  }

  // Get balance
  static async getBalance(userId) {
    try {
      const [rows] = await db.query(
        'SELECT balance FROM wallets WHERE user_id = ?',
        [userId]
      );
      return rows[0]?.balance || 0;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = Wallet;
