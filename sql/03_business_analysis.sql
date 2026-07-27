-- =====================================================
-- SALES DATA ENGINEERING PROJECT
-- Business Analysis SQL Queries
-- Table: raw_sales
-- Database: sales_reporting_project
-- =====================================================

USE sales_reporting_project;


-- 1. Overall Profit Margin
SELECT
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND((SUM(`Profit`) / NULLIF(SUM(`Sales`), 0)) * 100, 2) AS profit_margin_percentage
FROM raw_sales;


-- 2. Category Performance
SELECT
    `Category`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND((SUM(`Profit`) / NULLIF(SUM(`Sales`), 0)) * 100, 2) AS profit_margin_percentage
FROM raw_sales
GROUP BY `Category`
ORDER BY total_profit DESC;


-- 3. Sub-Category Performance
SELECT
    `Sub-Category`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND((SUM(`Profit`) / NULLIF(SUM(`Sales`), 0)) * 100, 2) AS profit_margin_percentage
FROM raw_sales
GROUP BY `Sub-Category`
ORDER BY total_profit DESC;


-- 4. Regional Performance
SELECT
    `Region`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND((SUM(`Profit`) / NULLIF(SUM(`Sales`), 0)) * 100, 2) AS profit_margin_percentage
FROM raw_sales
GROUP BY `Region`
ORDER BY total_profit DESC;


-- 5. Top 10 Customers by Revenue
SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit
FROM raw_sales
GROUP BY `Customer ID`, `Customer Name`
ORDER BY total_sales DESC
LIMIT 10;


-- 6. Top 10 Customers by Profit
SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND(SUM(`Sales`), 2) AS total_sales
FROM raw_sales
GROUP BY `Customer ID`, `Customer Name`
ORDER BY total_profit DESC
LIMIT 10;


-- 7. Products with High Sales but Low/Negative Profit
SELECT
    `Product Name`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND((SUM(`Profit`) / NULLIF(SUM(`Sales`), 0)) * 100, 2) AS profit_margin_percentage
FROM raw_sales
GROUP BY `Product Name`
HAVING SUM(`Sales`) > 1000
   AND SUM(`Profit`) <= 0
ORDER BY total_sales DESC;


-- 8. Impact of Discount on Profit
SELECT
    CASE
        WHEN `Discount` = 0 THEN '0% Discount'
        WHEN `Discount` <= 0.10 THEN '1-10% Discount'
        WHEN `Discount` <= 0.20 THEN '11-20% Discount'
        WHEN `Discount` <= 0.30 THEN '21-30% Discount'
        ELSE 'Above 30% Discount'
    END AS discount_range,
    COUNT(*) AS total_records,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND(AVG(`Profit`), 2) AS average_profit
FROM raw_sales
GROUP BY discount_range
ORDER BY total_profit DESC;


-- 9. Monthly Business Performance
SELECT
    DATE_FORMAT(`Order Date`, '%Y-%m') AS sales_month,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit,
    ROUND((SUM(`Profit`) / NULLIF(SUM(`Sales`), 0)) * 100, 2) AS profit_margin_percentage
FROM raw_sales
GROUP BY sales_month
ORDER BY sales_month;


-- 10. State-Level Performance
SELECT
    `State`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit
FROM raw_sales
GROUP BY `State`
ORDER BY total_profit DESC
LIMIT 10;


-- 11. States with Negative Profit
SELECT
    `State`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Profit`), 2) AS total_profit
FROM raw_sales
GROUP BY `State`
HAVING SUM(`Profit`) < 0
ORDER BY total_profit ASC;


-- 12. High-Value Orders
SELECT
    `Order ID`,
    `Customer Name`,
    ROUND(SUM(`Sales`), 2) AS order_value,
    ROUND(SUM(`Profit`), 2) AS order_profit
FROM raw_sales
GROUP BY `Order ID`, `Customer Name`
HAVING SUM(`Sales`) > 1000
ORDER BY order_value DESC
LIMIT 20;
