const Wallet = require('../models/Wallet');
const Transaction = require('../models/Transaction');
const { successResponse, errorResponse } = require('../utils/helpers');

// Get wallet balance
exports.getBalance = async (req, res) => {
  try {
    const userId = req.user.userId;
    
    const wallet = await Wallet.findByUserId(userId);
    
    if (!wallet) {
      return errorResponse(res, 'Wallet not found', 404);
    }
    
    return successResponse(res, {
      walletId: wallet.id,
      balance: parseFloat(wallet.balance),
      formattedBalance: `Rp ${parseFloat(wallet.balance).toLocaleString('id-ID')}`
    });
    
  } catch (error) {
    console.error('Get balance error:', error);
    return errorResponse(res, 'Failed to get balance', 500, error.message);
  }
};

// Get transaction history
exports.getTransactions = async (req, res) => {
  try {
    const userId = req.user.userId;
    const limit = parseInt(req.query.limit) || 10;
    
    const wallet = await Wallet.findByUserId(userId);
    
    if (!wallet) {
      return errorResponse(res, 'Wallet not found', 404);
    }
    
    const transactions = await Transaction.getByWalletId(wallet.id, limit);
    
    return successResponse(res, {
      transactions: transactions.map(tx => ({
        id: tx.id,
        orderId: tx.order_id,
        type: tx.type,
        amount: parseFloat(tx.amount),
        status: tx.status,
        paymentMethod: tx.payment_method,
        createdAt: tx.created_at
      }))
    });
    
  } catch (error) {
    console.error('Get transactions error:', error);
    return errorResponse(res, 'Failed to get transactions', 500, error.message);
  }
};
