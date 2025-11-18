const Product = require('../models/Product');
const { successResponse, errorResponse } = require('../utils/helpers');

// Get all products (browse buku)
exports.getAllProducts = async (req, res) => {
  try {
    const { category, search, inStock, limit } = req.query;
    
    const filters = {
      category,
      search,
      inStock: inStock === 'true',
      limit: limit || 50
    };
    
    const products = await Product.getAll(filters);
    
    return successResponse(res, {
      count: products.length,
      products: products.map(p => ({
        id: p.id,
        title: p.title,
        author: p.author,
        description: p.description,
        price: parseFloat(p.price),
        priceFormatted: `Rp ${parseFloat(p.price).toLocaleString('id-ID')}`,
        stock: p.stock,
        imageUrl: p.image_url,
        category: p.category,
        isbn: p.isbn
      }))
    });
  } catch (error) {
    console.error('Get products error:', error);
    return errorResponse(res, 'Failed to get products', 500, error.message);
  }
};

// Get product by ID (detail buku)
exports.getProductById = async (req, res) => {
  try {
    const productId = req.params.id;
    
    const product = await Product.findById(productId);
    
    if (!product) {
      return errorResponse(res, 'Product not found', 404);
    }
    
    return successResponse(res, {
      id: product.id,
      title: product.title,
      author: product.author,
      description: product.description,
      price: parseFloat(product.price),
      priceFormatted: `Rp ${parseFloat(product.price).toLocaleString('id-ID')}`,
      stock: product.stock,
      imageUrl: product.image_url,
      category: product.category,
      isbn: product.isbn,
      available: product.stock > 0
    });
  } catch (error) {
    console.error('Get product error:', error);
    return errorResponse(res, 'Failed to get product', 500, error.message);
  }
};

// Get categories
exports.getCategories = async (req, res) => {
  try {
    const categories = await Product.getCategories();
    
    return successResponse(res, {
      categories
    });
  } catch (error) {
    console.error('Get categories error:', error);
    return errorResponse(res, 'Failed to get categories', 500, error.message);
  }
};