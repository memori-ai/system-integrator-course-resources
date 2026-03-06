// Seed data for MCP Demo - MongoDB accessed by AIsuru Agent via MCP Server
// This script runs only on first initialization (empty volume)

db = db.getSiblingDB('mcp_demo');

// --- Products collection ---
db.products.insertMany([
  {
    name: "Laptop Pro 15",
    category: "Electronics",
    price: 1299.99,
    stock: 45,
    description: "High-performance laptop with 15-inch Retina display, M3 chip, 16GB RAM",
    tags: ["laptop", "premium", "portable"],
    createdAt: new Date("2025-01-15")
  },
  {
    name: "Wireless Mouse Ergonomic",
    category: "Accessories",
    price: 49.99,
    stock: 230,
    description: "Ergonomic wireless mouse with silent clicks and USB-C charging",
    tags: ["mouse", "ergonomic", "wireless"],
    createdAt: new Date("2025-02-10")
  },
  {
    name: "Mechanical Keyboard RGB",
    category: "Accessories",
    price: 129.99,
    stock: 87,
    description: "Mechanical keyboard with Cherry MX switches and per-key RGB lighting",
    tags: ["keyboard", "mechanical", "rgb"],
    createdAt: new Date("2025-01-20")
  },
  {
    name: "4K Monitor 27 inch",
    category: "Electronics",
    price: 449.99,
    stock: 32,
    description: "27-inch 4K UHD monitor with HDR support and USB-C connectivity",
    tags: ["monitor", "4k", "usb-c"],
    createdAt: new Date("2025-03-05")
  },
  {
    name: "USB-C Hub 7-in-1",
    category: "Accessories",
    price: 39.99,
    stock: 150,
    description: "Compact USB-C hub with HDMI, USB-A, SD card reader, and ethernet",
    tags: ["hub", "usb-c", "adapter"],
    createdAt: new Date("2025-02-28")
  },
  {
    name: "Noise Cancelling Headphones",
    category: "Audio",
    price: 299.99,
    stock: 64,
    description: "Over-ear headphones with active noise cancelling and 30-hour battery",
    tags: ["headphones", "anc", "bluetooth"],
    createdAt: new Date("2025-01-08")
  },
  {
    name: "Webcam HD 1080p",
    category: "Accessories",
    price: 79.99,
    stock: 112,
    description: "Full HD webcam with auto-focus, built-in microphone, and privacy shutter",
    tags: ["webcam", "streaming", "remote-work"],
    createdAt: new Date("2025-03-12")
  },
  {
    name: "Standing Desk Electric",
    category: "Furniture",
    price: 599.99,
    stock: 18,
    description: "Electric height-adjustable standing desk with memory presets, 160x80cm",
    tags: ["desk", "standing", "ergonomic"],
    createdAt: new Date("2025-02-14")
  }
]);

// --- Customers collection ---
db.customers.insertMany([
  {
    firstName: "Marco",
    lastName: "Rossi",
    email: "marco.rossi@example.com",
    city: "Milano",
    country: "Italy",
    totalOrders: 12,
    totalSpent: 2450.80,
    memberSince: new Date("2024-03-15"),
    tier: "Gold"
  },
  {
    firstName: "Laura",
    lastName: "Bianchi",
    email: "laura.bianchi@example.com",
    city: "Roma",
    country: "Italy",
    totalOrders: 5,
    totalSpent: 890.50,
    memberSince: new Date("2024-09-20"),
    tier: "Silver"
  },
  {
    firstName: "John",
    lastName: "Smith",
    email: "john.smith@example.com",
    city: "London",
    country: "United Kingdom",
    totalOrders: 23,
    totalSpent: 5670.00,
    memberSince: new Date("2023-11-01"),
    tier: "Platinum"
  },
  {
    firstName: "Anna",
    lastName: "Mueller",
    email: "anna.mueller@example.com",
    city: "Berlin",
    country: "Germany",
    totalOrders: 8,
    totalSpent: 1320.75,
    memberSince: new Date("2024-06-10"),
    tier: "Gold"
  },
  {
    firstName: "Sofia",
    lastName: "Conti",
    email: "sofia.conti@example.com",
    city: "Torino",
    country: "Italy",
    totalOrders: 2,
    totalSpent: 179.98,
    memberSince: new Date("2025-01-05"),
    tier: "Bronze"
  }
]);

// --- Orders collection ---
db.orders.insertMany([
  {
    customerEmail: "marco.rossi@example.com",
    items: [
      { product: "Laptop Pro 15", quantity: 1, price: 1299.99 },
      { product: "Wireless Mouse Ergonomic", quantity: 1, price: 49.99 }
    ],
    total: 1349.98,
    status: "delivered",
    orderDate: new Date("2025-01-20"),
    shippingAddress: "Via Roma 42, Milano, Italy"
  },
  {
    customerEmail: "john.smith@example.com",
    items: [
      { product: "4K Monitor 27 inch", quantity: 2, price: 449.99 },
      { product: "Standing Desk Electric", quantity: 1, price: 599.99 }
    ],
    total: 1499.97,
    status: "delivered",
    orderDate: new Date("2025-02-05"),
    shippingAddress: "10 Downing St, London, UK"
  },
  {
    customerEmail: "laura.bianchi@example.com",
    items: [
      { product: "Noise Cancelling Headphones", quantity: 1, price: 299.99 },
      { product: "USB-C Hub 7-in-1", quantity: 1, price: 39.99 }
    ],
    total: 339.98,
    status: "shipped",
    orderDate: new Date("2025-03-10"),
    shippingAddress: "Via del Corso 15, Roma, Italy"
  },
  {
    customerEmail: "anna.mueller@example.com",
    items: [
      { product: "Mechanical Keyboard RGB", quantity: 1, price: 129.99 },
      { product: "Webcam HD 1080p", quantity: 1, price: 79.99 }
    ],
    total: 209.98,
    status: "processing",
    orderDate: new Date("2025-03-15"),
    shippingAddress: "Friedrichstrasse 100, Berlin, Germany"
  },
  {
    customerEmail: "sofia.conti@example.com",
    items: [
      { product: "Wireless Mouse Ergonomic", quantity: 2, price: 49.99 },
      { product: "USB-C Hub 7-in-1", quantity: 2, price: 39.99 }
    ],
    total: 179.96,
    status: "delivered",
    orderDate: new Date("2025-02-20"),
    shippingAddress: "Corso Francia 8, Torino, Italy"
  }
]);

print("--- MCP Demo seed data loaded successfully ---");
print("Database: mcp_demo");
print("Collections: products (" + db.products.countDocuments({}) + "), customers (" + db.customers.countDocuments({}) + "), orders (" + db.orders.countDocuments({}) + ")");
