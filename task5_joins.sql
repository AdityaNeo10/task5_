
-- Reset the database
DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- Create Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Products Table
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0
);

-- Create Orders Table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create OrderItems Table
CREATE TABLE OrderItems (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Create Payments Table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL,
    method ENUM('Credit Card', 'Debit Card', 'UPI', 'Cash on Delivery') NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- INSERT DATA

-- Insert Users
INSERT INTO Users (name, email, password) VALUES
('Aditya Kumar', 'aditya@example.com', 'pass123'),
('Rohit Mehra', 'rohit@example.com', 'rohit123'),
('Sana Shaikh', 'sana@example.com', 'sana456');

-- Insert Products (one product has NULL description)
INSERT INTO Products (name, description, price, stock) VALUES
('Laptop', '14-inch slim laptop', 799.99, 10),
('Wireless Mouse', NULL, 25.00, 50),
('Keyboard', 'Mechanical RGB keyboard', 45.00, 30);

-- Insert Orders
INSERT INTO Orders (user_id, status) VALUES
(1, 'Pending'),
(2, 'Shipped'),
(3, 'Delivered');

-- Insert OrderItems
INSERT INTO OrderItems (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 799.99),
(1, 2, 2, 50.00),
(2, 3, 1, 45.00);

-- Insert Payments
INSERT INTO Payments (order_id, amount, method) VALUES
(1, 849.99, 'Credit Card'),
(2, 45.00, 'UPI'),
(3, 45.00, 'Cash on Delivery');

-- INNER JOIN: Get all orders with user names
SELECT Orders.order_id, Users.name, Orders.status
FROM Orders
INNER JOIN Users ON Orders.user_id = Users.user_id;

-- LEFT JOIN: Show all users and their orders (even if no order)
SELECT Users.name, Orders.order_id, Orders.status
FROM Users
LEFT JOIN Orders ON Users.user_id = Orders.user_id;

-- RIGHT JOIN: Show all orders and their users (even if user missing)
-- Note: RIGHT JOIN works in MySQL but not in SQLite
SELECT Users.name, Orders.order_id, Orders.status
FROM Users
RIGHT JOIN Orders ON Users.user_id = Orders.user_id;

-- FULL OUTER JOIN: Combine all users and orders (matched or not)
-- MySQL workaround using UNION
SELECT Users.name, Orders.order_id, Orders.status
FROM Users
LEFT JOIN Orders ON Users.user_id = Orders.user_id

UNION

SELECT Users.name, Orders.order_id, Orders.status
FROM Users
RIGHT JOIN Orders ON Users.user_id = Orders.user_id;
