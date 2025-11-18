const Wallet = require('../models/Wallet');
const Transaction = require('../models/Transaction');
const User = require('../models/User');
const FinpayService = require('../services/finpayService');
const { generateOrderId, successResponse, errorResponse } = require('../utils/helpers');

// Initiate topup
exports.initiateTopup = async (req, res) => {
  try {
    const userId = req.user.userId;
    const { amount } = req.body;
    
    // Validasi amount
    if (!amount || amount < 10000) {
      return errorResponse(res, 'Minimum topup amount is Rp 10.000', 400);
    }
    
    if (amount > 50000000) {
      return errorResponse(res, 'Maximum topup amount is Rp 50.000.000', 400);
    }
    
    // Get user & wallet
    const user = await User.findById(userId);
    const wallet = await Wallet.findByUserId(userId);
    
    if (!wallet) {
      return errorResponse(res, 'Wallet not found', 404);
    }
    
    // Generate order ID
    const orderId = generateOrderId();
    
    // Call Finpay API
    const finpayResponse = await FinpayService.initiatePayment({
      orderId,
      amount,
      customerEmail: user.email,
      customerFirstName: user.first_name,
      customerLastName: user.last_name,
      customerPhone: user.mobile_phone
    });
    
    if (!finpayResponse.success) {
      return errorResponse(res, 'Failed to initiate payment', 500, finpayResponse.error);
    }
    
    // Save transaction to database
    await Transaction.create({
      walletId: wallet.id,
      orderId,
      type: 'topup',
      amount,
      status: 'pending',
      finpayResponse: JSON.stringify(finpayResponse.data),
      redirectUrl: finpayResponse.data.redirecturl
    });
    
    return successResponse(res, {
      orderId,
      amount,
      redirectUrl: finpayResponse.data.redirecturl,
      expiryLink: finpayResponse.data.expiryLink
    }, 'Payment initiated successfully');
    
  } catch (error) {
    console.error('Initiate topup error:', error);
    return errorResponse(res, 'Failed to initiate topup', 500, error.message);
  }
};

// Callback handler dari Finpay
exports.handleCallback = async (req, res) => {
  try {
    const callbackData = req.body;
    
    console.log('📩 Received callback from Finpay:', JSON.stringify(callbackData, null, 2));
    
    // Parse callback
    const parsed = FinpayService.parseCallback(callbackData);
    
    if (!parsed) {
      return errorResponse(res, 'Invalid callback data', 400);
    }
    
    // Validate signature
    if (!parsed.isValid) {
      console.error('❌ Invalid signature!');
      return errorResponse(res, 'Invalid signature', 401);
    }
    
    // Get transaction
    const transaction = await Transaction.findByOrderId(parsed.orderId);
    
    if (!transaction) {
      return errorResponse(res, 'Transaction not found', 404);
    }
    
    // Check if already processed
    if (transaction.status === 'success') {
      console.log('⚠️ Transaction already processed');
      return successResponse(res, null, 'Transaction already processed');
    }
    
    // Update transaction status based on payment status
    // Update transaction status based on payment status
    if (parsed.paymentStatus === 'CAPTURED' || parsed.paymentStatus === 'PAID') {
    // Update transaction status
    await Transaction.updateStatus(parsed.orderId, 'success', JSON.stringify(callbackData));
    
    // Update wallet balance
    await Wallet.updateBalance(transaction.wallet_id, transaction.amount);
    
    console.log(`✅ Topup success! Order: ${parsed.orderId}, Amount: ${transaction.amount}`);
    
    return successResponse(res, {
        responseCode: '2000000',
        responseMessage: 'Success',
        processingTime: 0.5
    });
    } else {
    // Payment failed
    await Transaction.updateStatus(parsed.orderId, 'failed', JSON.stringify(callbackData));
    
    console.log(`❌ Payment failed! Order: ${parsed.orderId}, Status: ${parsed.paymentStatus}`);
    
    return successResponse(res, {
        responseCode: '2000000',
        responseMessage: 'Success',
        processingTime: 0.5
    });
    }
    
  } catch (error) {
    console.error('Callback handler error:', error);
    return errorResponse(res, 'Callback processing failed', 500, error.message);
  }
};