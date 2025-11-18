const axios = require('axios');
const crypto = require('crypto');
require('dotenv').config();

const FINPAY_BASE_URL = process.env.FINPAY_BASE_URL;
const MERCHANT_ID = process.env.FINPAY_MERCHANT_ID;
const MERCHANT_KEY = process.env.FINPAY_MERCHANT_KEY;

class FinpayService {
  
  // Generate Basic Auth
  static getAuthHeader() {
    const credentials = Buffer.from(`${MERCHANT_ID}:${MERCHANT_KEY}`).toString('base64');
    return `Basic ${credentials}`;
  }

  // Initiate Hosted Payment (untuk Topup atau Order)
static async initiatePayment(orderData) {
  try {
    const { orderId, amount, customerEmail, customerFirstName, customerLastName, customerPhone, callbackUrl, callbackType } = orderData;
    
    // Determine callback URL
    let finalCallbackUrl = callbackUrl || process.env.CALLBACK_URL;
    
    // If callbackType is 'order', use callback-order endpoint
    if (callbackType === 'order') {
      finalCallbackUrl = finalCallbackUrl.replace('/callback', '/callback-order');
    }
    
    const requestBody = {
      customer: {
        email: customerEmail,
        firstName: customerFirstName,
        lastName: customerLastName,
        mobilePhone: customerPhone
      },
      order: {
        id: orderId,
        amount: amount.toString(),
        description: callbackType === 'order' ? 'Order NUKAR Marketplace' : 'Topup Wallet NUKAR'
      },
      url: {
        callbackUrl: finalCallbackUrl
      }
    };

    const response = await axios.post(
      `${FINPAY_BASE_URL}/pg/payment/card/initiate`,
      requestBody,
      {
        headers: {
          'Authorization': this.getAuthHeader(),
          'Content-Type': 'application/json'
        }
      }
    );

    return {
      success: true,
      data: response.data
    };
  } catch (error) {
    console.error('Finpay API Error:', error.response?.data || error.message);
    return {
      success: false,
      error: error.response?.data || error.message
    };
  }
}

  // Validate Callback Signature
  static validateSignature(callbackData, signature) {
    try {
      // Remove signature from data
      const { signature: _, ...fieldsWithoutSignature } = callbackData;
      
      // Generate signature
      const generatedSignature = crypto
        .createHmac('sha512', MERCHANT_KEY)
        .update(JSON.stringify(fieldsWithoutSignature))
        .digest('hex');
      
      return generatedSignature === signature;
    } catch (error) {
      console.error('Signature validation error:', error);
      return false;
    }
  }

  // Parse Callback Data
  static parseCallback(callbackBody) {
    try {
      const orderId = callbackBody.order?.id;
      const amount = callbackBody.order?.amount;
      const paymentStatus = callbackBody.result?.payment?.status;
      const signature = callbackBody.signature;
      
      return {
        orderId,
        amount,
        paymentStatus,
        signature,
        isValid: this.validateSignature(callbackBody, signature)
      };
    } catch (error) {
      console.error('Parse callback error:', error);
      return null;
    }
  }
}

module.exports = FinpayService;
