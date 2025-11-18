const db = require('../config/database');

class Product {
  // Get all products
  static async getAll(filters = {}) {
    try {
      let query = 'SELECT * FROM products WHERE 1=1';
      const params = [];
      
      // Filter by category
      if (filters.category) {
        query += ' AND category = ?';
        params.push(filters.category);
      }
      
      // Search by title or author
      if (filters.search) {
        query += ' AND (title LIKE ? OR author LIKE ?)';
        params.push(`%${filters.search}%`, `%${filters.search}%`);
      }
      
      // Only show in-stock products
      if (filters.inStock) {
        query += ' AND stock > 0';
      }
      
      query += ' ORDER BY created_at DESC';
      
      // Limit
      if (filters.limit) {
        query += ' LIMIT ?';
        params.push(parseInt(filters.limit));
      }
      
      const [rows] = await db.query(query, params);
      return rows;
    } catch (error) {
      throw error;
    }
  }

  // Get product by ID
  static async findById(id) {
    try {
      const [rows] = await db.query('SELECT * FROM products WHERE id = ?', [id]);
      return rows[0] || null;
    } catch (error) {
      throw error;
    }
  }

  // Create product
  static async create(productData) {
    try {
      const { title, author, description, price, stock, imageUrl, category, isbn } = productData;
      
      const [result] = await db.query(
        'INSERT INTO products (title, author, description, price, stock, image_url, category, isbn) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [title, author, description, price, stock || 0, imageUrl || null, category || null, isbn || null]
      );
      
      return result.insertId;
    } catch (error) {
      throw error;
    }
  }

  // Update stock
  static async updateStock(productId, quantity) {
    try {
      const [result] = await db.query(
        'UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?',
        [quantity, productId, quantity]
      );
      
      return result.affectedRows > 0;
    } catch (error) {
      throw error;
    }
  }

  // Get categories
  static async getCategories() {
    try {
      const [rows] = await db.query('SELECT DISTINCT category FROM products WHERE category IS NOT NULL ORDER BY category');
      return rows.map(row => row.category);
    } catch (error) {
      throw error;
    }
  }
}

module.exports = Product;