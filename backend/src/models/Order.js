const db = require('../config/database');

class Order {
  // Create new order
  static async create(orderData) {
    const connection = await db.getConnection();
    
    try {
      await connection.beginTransaction();
      
      const { userId, orderNumber, totalAmount, paymentMethod, items, finpayOrderId, finpayRedirectUrl } = orderData;
      
      // Insert order
      const [orderResult] = await connection.query(
        'INSERT INTO orders (user_id, order_number, total_amount, payment_method, finpay_order_id, finpay_redirect_url) VALUES (?, ?, ?, ?, ?, ?)',
        [userId, orderNumber, totalAmount, paymentMethod, finpayOrderId || null, finpayRedirectUrl || null]
      );
      
      const orderId = orderResult.insertId;
      
      // Insert order items
      for (const item of items) {
        await connection.query(
          'INSERT INTO order_items (order_id, product_id, quantity, price, subtotal) VALUES (?, ?, ?, ?, ?)',
          [orderId, item.productId, item.quantity, item.price, item.subtotal]
        );
        
        // Update product stock
        await connection.query(
          'UPDATE products SET stock = stock - ? WHERE id = ?',
          [item.quantity, item.productId]
        );
      }
      
      await connection.commit();
      return orderId;
    } catch (error) {
      await connection.rollback();
      throw error;
    } finally {
      connection.release();
    }
  }

  // Find order by ID
  static async findById(orderId) {
    try {
      const [orders] = await db.query(
        `SELECT o.*, u.email, u.first_name, u.last_name 
         FROM orders o
         JOIN users u ON o.user_id = u.id
         WHERE o.id = ?`,
        [orderId]
      );
      
      if (orders.length === 0) return null;
      
      // Get order items
      const [items] = await db.query(
        `SELECT oi.*, p.title, p.author, p.image_url
         FROM order_items oi
         JOIN products p ON oi.product_id = p.id
         WHERE oi.order_id = ?`,
        [orderId]
      );
      
      return {
        ...orders[0],
        items
      };
    } catch (error) {
      throw error;
    }
  }

  // Find order by order number
  static async findByOrderNumber(orderNumber) {
    try {
      const [orders] = await db.query(
        `SELECT o.*, u.email, u.first_name, u.last_name 
         FROM orders o
         JOIN users u ON o.user_id = u.id
         WHERE o.order_number = ?`,
        [orderNumber]
      );
      
      if (orders.length === 0) return null;
      
      // Get order items
      const [items] = await db.query(
        `SELECT oi.*, p.title, p.author, p.image_url
         FROM order_items oi
         JOIN products p ON oi.product_id = p.id
         WHERE oi.order_id = ?`,
        [orders[0].id]
      );
      
      return {
        ...orders[0],
        items
      };
    } catch (error) {
      throw error;
    }
  }

  // Find order by Finpay order ID
  static async findByFinpayOrderId(finpayOrderId) {
    try {
      const [orders] = await db.query('SELECT * FROM orders WHERE finpay_order_id = ?', [finpayOrderId]);
      return orders[0] || null;
    } catch (error) {
      throw error;
    }
  }

  // Get orders by user ID
  static async getByUserId(userId, limit = 10) {
    try {
      const [orders] = await db.query(
        `SELECT o.* FROM orders o
         WHERE o.user_id = ?
         ORDER BY o.created_at DESC
         LIMIT ?`,
        [userId, limit]
      );
      
      // Get items for each order
      for (let order of orders) {
        const [items] = await db.query(
          `SELECT oi.*, p.title, p.author
           FROM order_items oi
           JOIN products p ON oi.product_id = p.id
           WHERE oi.order_id = ?`,
          [order.id]
        );
        order.items = items;
      }
      
      return orders;
    } catch (error) {
      throw error;
    }
  }

  // Update payment status
  static async updatePaymentStatus(orderNumber, status) {
    try {
      const [result] = await db.query(
        'UPDATE orders SET payment_status = ? WHERE order_number = ?',
        [status, orderNumber]
      );
      
      return result.affectedRows > 0;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = Order;