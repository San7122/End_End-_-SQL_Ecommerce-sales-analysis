-- FINAL_ECOMMERCE_SQL_PROJECT.sql

-- 📁 Create Database
CREATE DATABASE EcommerceDB;
USE EcommerceDB;

-- 🔍 View Tables
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM products;

-- ✅ Total Number of Orders Placed
SELECT 
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;

-- 💰 Total Revenue Calculation
SELECT 
    ROUND(SUM(oi.quantity * p.price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;

-- 🧍 Total Unique Customers
SELECT 
    COUNT(DISTINCT customer_id) AS total_customers
FROM customers;

-- 🥇 Top-Selling Product by Quantity
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 1;

-- 📊 Revenue by Product
SELECT 
    p.product_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- 🧁 Sales by Category
SELECT 
    p.category,
    SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- ⏰ Orders by Hour
SELECT 
    HOUR(order_time) AS hour,
    COUNT(order_id) AS order_count
FROM orders
GROUP BY HOUR(order_time)
ORDER BY hour;

-- 🧾 Top 5 Customers by Revenue
SELECT 
    c.name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_revenue DESC
LIMIT 5;

-- 📈 Cumulative Revenue Over Time
SELECT 
    order_date,
    SUM(daily_revenue) OVER (ORDER BY order_date) AS cumulative_revenue
FROM (
    SELECT 
        o.order_date,
        SUM(oi.quantity * p.price) AS daily_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY o.order_date
) AS daily_sales;
