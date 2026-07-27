-- =====================================================
-- SALES DATA ENGINEERING PROJECT
-- Data Validation Checks
-- Table: raw_sales
-- Database: sales_reporting_project
-- =====================================================

USE sales_reporting_project;


-- 1. Check total number of records
SELECT COUNT(*) AS total_records
FROM raw_sales;


-- 2. Check duplicate Order IDs
SELECT 
    `Order ID`,
    COUNT(*) AS duplicate_count
FROM raw_sales
GROUP BY `Order ID`
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- 3. Check NULL values in key columns
SELECT
    SUM(CASE WHEN `Order ID` IS NULL OR `Order ID` = '' THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN `Customer ID` IS NULL OR `Customer ID` = '' THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN `Product ID` IS NULL OR `Product ID` = '' THEN 1 ELSE 0 END) AS missing_product_id,
    SUM(CASE WHEN `Sales` IS NULL THEN 1 ELSE 0 END) AS missing_sales,
    SUM(CASE WHEN `Profit` IS NULL THEN 1 ELSE 0 END) AS missing_profit
FROM raw_sales;


-- 4. Check invalid negative sales
SELECT COUNT(*) AS negative_sales_records
FROM raw_sales
WHERE `Sales` < 0;


-- 5. Check negative profit records
SELECT COUNT(*) AS negative_profit_records
FROM raw_sales
WHERE `Profit` < 0;


-- 6. Check invalid quantity values
SELECT COUNT(*) AS invalid_quantity_records
FROM raw_sales
WHERE `Quantity` <= 0;


-- 7. Check date range
SELECT
    MIN(`Order Date`) AS earliest_order_date,
    MAX(`Order Date`) AS latest_order_date
FROM raw_sales;


-- 8. Check distinct values for key dimensions
SELECT
    COUNT(DISTINCT `Customer ID`) AS unique_customers,
    COUNT(DISTINCT `Product ID`) AS unique_products,
    COUNT(DISTINCT `Category`) AS unique_categories,
    COUNT(DISTINCT `Region`) AS unique_regions
FROM raw_sales;
