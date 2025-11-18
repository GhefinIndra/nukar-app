const Order = require('../models/Order');
const Product = require('../models/Product');
const Wallet = require('../models/Wallet');
const Transaction = require('../models/Transaction');
const User = require('../models/User');
const FinpayService = require('../services/finpayService');
const { generateOrderNumber, generateOrderId, successResponse, errorResponse } = require('../utils/helpers');

// Checkout - Beli buku
exports.checkout = async (req, res) => {
  try {
    const userId = req.user.userId;
    const { items, paymentMethod } = req.body;
    
    // Validasi input
    if (!items || !Array.isArray(items) || items.length === 0) {
      return errorResponse(res, 'Items are required', 400);
    }
    
    if (!paymentMethod || !['wallet', 'finpay'].includes(paymentMethod)) {
      return errorResponse(res, 'Invalid payment method. Use "wallet" or "finpay"', 400);
    }
    
    // Get user & wallet
    const user = await User.findById(userId);
    const wallet = await Wallet.findByUserId(userId);
    
    if (!wallet) {
      return errorResponse(res, 'Wallet not found', 404);
    }
    
    // Validate & calculate total
    let totalAmount = 0;
    const orderItems = [];
    
    for (const item of items) {
      const product = await Product.findById(item.productId);
      
      if (!product) {
        return errorResponse(res, `Product ID ${item.productId} not found`, 404);
      }
      
      if (product.stock < item.quantity) {
        return errorResponse(res, `Insufficient stock for "${product.title}". Available: ${product.stock}`, 400);
      }
      
      const subtotal = parseFloat(product.price) * item.quantity;
      totalAmount += subtotal;
      
      orderItems.push({
        productId: product.id,
        quantity: item.quantity,
        price: parseFloat(product.price),
        subtotal
      });
    }
    
    // Generate order number
    const orderNumber = generateOrderNumber();
    
    // Payment Method: WALLET
    if (paymentMethod === 'wallet') {
      // Check balance
      if (parseFloat(wallet.balance) < totalAmount) {
        return errorResponse(res, 'Insufficient wallet balance', 400);
      }
      
      // Create order
      const orderId = await Order.create({
        userId,
        orderNumber,
        totalAmount,
        paymentMethod: 'wallet',
        items: orderItems
      });
      
      // Deduct wallet balance
      await Wallet.updateBalance(wallet.id, -totalAmount);
      
      // Create transaction record
      await Transaction.create({
        walletId: wallet.id,
        orderId: orderNumber,
        type: 'payment',
        amount: -totalAmount,
        status: 'success',
        paymentMethod: 'wallet'
      });
      
      // Update order status to paid
      await Order.updatePaymentStatus(orderNumber, 'paid');
      
      console.log(`✅ Order paid with wallet! Order: ${orderNumber}, Amount: ${totalAmount}`);
      
      return successResponse(res, {
        orderNumber,
        orderId,
        totalAmount,
        paymentMethod: 'wallet',
        paymentStatus: 'paid',
        message: 'Order successfully paid with wallet balance'
      }, 'Checkout successful', 201);
    }
    
    // Payment Method: FINPAY
    if (paymentMethod === 'finpay') {
      // Generate Finpay order ID
      const finpayOrderId = generateOrderId();
      
      // Call Finpay API
      const finpayResponse = await FinpayService.initiatePayment({
        orderId: finpayOrderId,
        amount: totalAmount,
        customerEmail: user.email,
        customerFirstName: user.first_name,
        customerLastName: user.last_name,
        customerPhone: user.mobile_phone,
        callbackType: 'order'
      });
      
      if (!finpayResponse.success) {
        return errorResponse(res, 'Failed to initiate payment', 500, finpayResponse.error);
      }
      
      // Create order
      const orderId = await Order.create({
        userId,
        orderNumber,
        totalAmount,
        paymentMethod: 'finpay',
        items: orderItems,
        finpayOrderId,
        finpayRedirectUrl: finpayResponse.data.redirecturl
      });
      
      console.log(`🔄 Order created with Finpay payment! Order: ${orderNumber}, Finpay Order: ${finpayOrderId}`);
      
      return successResponse(res, {
        orderNumber,
        orderId,
        totalAmount,
        paymentMethod: 'finpay',
        paymentStatus: 'pending',
        redirectUrl: finpayResponse.data.redirecturl,
        expiryLink: finpayResponse.data.expiryLink,
        message: 'Please complete payment via Finpay'
      }, 'Checkout successful', 201);
    }
    
  } catch (error) {
    console.error('Checkout error:', error);
    return errorResponse(res, 'Checkout failed', 500, error.message);
  }
};

// Get order by order number
exports.getOrder = async (req, res) => {
  try {
    const userId = req.user.userId;
    const orderNumber = req.params.orderNumber;
    
    const order = await Order.findByOrderNumber(orderNumber);
    
    if (!order) {
      return errorResponse(res, 'Order not found', 404);
    }
    
    // Check ownership
    if (order.user_id !== userId) {
      return errorResponse(res, 'Unauthorized', 403);
    }
    
    return successResponse(res, {
      orderNumber: order.order_number,
      totalAmount: parseFloat(order.total_amount),
      paymentMethod: order.payment_method,
      paymentStatus: order.payment_status,
      items: order.items.map(item => ({
        productId: item.product_id,
        title: item.title,
        author: item.author,
        quantity: item.quantity,
        price: parseFloat(item.price),
        subtotal: parseFloat(item.subtotal)
      })),
      createdAt: order.created_at
    });
  } catch (error) {
    console.error('Get order error:', error);
    return errorResponse(res, 'Failed to get order', 500, error.message);
  }
};

// Get user's orders
exports.getMyOrders = async (req, res) => {
  try {
    const userId = req.user.userId;
    const limit = parseInt(req.query.limit) || 10;
    
    const orders = await Order.getByUserId(userId, limit);
    
    return successResponse(res, {
      orders: orders.map(order => ({
        orderNumber: order.order_number,
        totalAmount: parseFloat(order.total_amount),
        paymentMethod: order.payment_method,
        paymentStatus: order.payment_status,
        itemCount: order.items.length,
        items: order.items.map(item => ({
          title: item.title,
          author: item.author,
          quantity: item.quantity,
          price: parseFloat(item.price)
        })),
        createdAt: order.created_at
      }))
    });
  } catch (error) {
    console.error('Get orders error:', error);
    return errorResponse(res, 'Failed to get orders', 500, error.message);
  }
};