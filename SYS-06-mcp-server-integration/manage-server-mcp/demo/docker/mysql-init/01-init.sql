-- Initialize MySQL database for MCP Demo 2
-- This script creates tables and inserts sample data

USE mcp_demo_mysql;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  role VARCHAR(50) DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  stock INT DEFAULT 0,
  category VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  total_amount DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample users
INSERT INTO users (name, email, role) VALUES
  ('Alice Johnson', 'alice@example.com', 'admin'),
  ('Bob Smith', 'bob@example.com', 'user'),
  ('Charlie Brown', 'charlie@example.com', 'user'),
  ('Diana Prince', 'diana@example.com', 'user'),
  ('Eve Torres', 'eve@example.com', 'moderator');

-- Insert sample products
INSERT INTO products (name, description, price, stock, category) VALUES
  ('Laptop Pro 15"', 'High-performance laptop with 16GB RAM', 1299.99, 25, 'Electronics'),
  ('Wireless Mouse', 'Ergonomic wireless mouse with precision tracking', 29.99, 150, 'Electronics'),
  ('USB-C Cable', 'Premium braided USB-C charging cable', 14.99, 300, 'Accessories'),
  ('Mechanical Keyboard', 'RGB backlit mechanical keyboard', 89.99, 50, 'Electronics'),
  ('Desk Lamp', 'LED desk lamp with adjustable brightness', 39.99, 80, 'Office'),
  ('Notebook Set', 'Pack of 3 premium notebooks', 19.99, 200, 'Stationery'),
  ('Webcam HD', '1080p HD webcam with built-in microphone', 69.99, 60, 'Electronics'),
  ('Monitor Stand', 'Adjustable monitor stand with storage', 44.99, 40, 'Office'),
  ('Phone Holder', 'Adjustable phone holder for desk', 12.99, 120, 'Accessories'),
  ('Coffee Mug', 'Insulated stainless steel coffee mug', 24.99, 100, 'Kitchenware');

-- Insert sample orders
INSERT INTO orders (user_id, total_amount, status) VALUES
  (1, 1329.98, 'completed'),
  (2, 89.99, 'completed'),
  (3, 44.98, 'pending'),
  (4, 1369.98, 'shipped'),
  (5, 109.98, 'processing');

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
