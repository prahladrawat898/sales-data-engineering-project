-- =====================================================
-- SALES DATA ENGINEERING PROJECT
-- Exploratory Data Analysis (EDA) Queries
-- Table: raw_sales
-- Database: sales_reporting_project
-- =====================================================

USE sales_reporting_project;


-- 1. Overall Sales and Profit Performance
SELECT
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    SUM(`Quantity`) AS total_quantity,
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM raw_sales;


-- 2. Sales and Profit by Category
SELECT
    `Category`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    SUM(`Quantity`) AS total_quantity
FROM raw_sales
GROUP BY `Category`
ORDER BY total_sales DESC;


-- 3. Sales and Profit by Region
SELECT
    `Region`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit
FROM raw_sales
GROUP BY `Region`
ORDER BY total_sales DESC;


-- 4. Top 10 Products by Sales
SELECT
    `Product Name`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit
FROM raw_sales
GROUP BY `Product Name`
ORDER BY total_sales DESC
LIMIT 10;


-- 5. Top 10 Products by Profit
SELECT
    `Product Name`,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND(SUM(`Sales`), 2) AS total_sales
FROM raw_sales
GROUP BY `Product Name`
ORDER BY total_profit DESC
LIMIT 10;


-- 6. Least Profitable Products
SELECT
    `Product Name`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit
FROM raw_sales
GROUP BY `Product Name`
ORDER BY total_profit ASC
LIMIT 10;


-- 7. Sales and Profit by Customer Segment
SELECT
    `Segment`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    COUNT(DISTINCT `Customer ID`) AS unique_customers
FROM raw_sales
GROUP BY `Segment`
ORDER BY total_sales DESC;


-- 8. Monthly Sales Trend
SELECT
    DATE_FORMAT(`Order Date`, '%Y-%m') AS sales_month,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit
FROM raw_sales
GROUP BY sales_month
ORDER BY sales_month;


-- 9. Sales by Ship Mode
SELECT
    `Ship Mode`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM raw_sales
GROUP BY `Ship Mode`
ORDER BY total_sales DESC;


-- 10. Average Discount by Category
SELECT
    `Category`,
    ROUND(AVG(`Discount`) * 100, 2) AS average_discount_percentage
FROM raw_sales
GROUP BY `Category`
ORDER BY average_discount_percentage DESC;


-- 11. Loss-Making Categories
SELECT
    `Category`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit
FROM raw_sales
GROUP BY `Category`
HAVING SUM(`Profit`) < 0
ORDER BY total_profit ASC;


-- 12. Loss-Making Regions
SELECT
    `Region`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit
FROM raw_sales
GROUP BY `Region`
HAVING SUM(`Profit`) < 0
ORDER BY total_profit ASC;
