const db = require('../config/database');

class Transaction {
  // Create new transaction
  static async create(transactionData) {
    try {
      const { walletId, orderId, type, amount, status, paymentMethod, finpayResponse, redirectUrl } = transactionData;
      
      const [result] = await db.query(
        'INSERT INTO transactions (wallet_id, order_id, type, amount, status, payment_method, finpay_response, redirect_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [walletId, orderId, type, amount, status || 'pending', paymentMethod || null, finpayResponse || null, redirectUrl || null]
      );
      
      return result.insertId;
    } catch (error) {
      throw error;
    }
  }

  // Find transaction by order ID
  static async findByOrderId(orderId) {
    try {
      const [rows] = await db.query('SELECT * FROM transactions WHERE order_id = ?', [orderId]);
      return rows[0] || null;
    } catch (error) {
      throw error;
    }
  }

  // Update transaction status
  static async updateStatus(orderId, status, finpayResponse = null) {
    try {
      const [result] = await db.query(
        'UPDATE transactions SET status = ?, finpay_response = ? WHERE order_id = ?',
        [status, finpayResponse, orderId]
      );
      
      return result.affectedRows > 0;
    } catch (error) {
      throw error;
    }
  }

  // Get transactions by wallet ID
  static async getByWalletId(walletId, limit = 10) {
    try {
      const [rows] = await db.query(
        'SELECT * FROM transactions WHERE wallet_id = ? ORDER BY created_at DESC LIMIT ?',
        [walletId, limit]
      );
      return rows;
    } catch (error) {
      throw error;
    }
  }

  // Get transaction by ID
  static async findById(id) {
    try {
      const [rows] = await db.query('SELECT * FROM transactions WHERE id = ?', [id]);
      return rows[0] || null;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = Transaction;
