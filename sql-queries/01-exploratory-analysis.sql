-- ==========================================
-- 01. EXPLORATORY DATA ANALYSIS
-- ==========================================
-- Author: [Your Name]
-- Date: February 2026
-- Description: Initial data exploration queries for retail Brazil dataset
-- ==========================================

-- ==========================================
-- 1.1 Check Data Types of Customers Table
-- ==========================================

SELECT 
    column_name, 
    data_type 
FROM sharan-dsml-sql.business_case_retail.INFORMATION_SCHEMA.COLUMNS 
WHERE table_name = 'customers';

/*
Expected Output:
- customer_id: STRING
- customer_unique_id: STRING
- customer_zip_code_prefix: STRING
- customer_city: STRING
- customer_state: STRING
*/


-- ==========================================
-- 1.2 Get Time Range of Orders
-- ==========================================

SELECT 
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS last_order,
    DATE_DIFF(
        CAST(MAX(order_purchase_timestamp) AS DATE),
        CAST(MIN(order_purchase_timestamp) AS DATE),
        DAY
    ) AS total_days
FROM sharan-dsml-sql.business_case_retail.orders;

/*
Business Insight:
- Identifies the active period of the dataset
- Helps define scope for time-based analysis
- Reveals dataset span for trend identification
*/


-- ==========================================
-- 1.3 Count Customers by City and State
-- ==========================================

SELECT 
    customer_state,
    customer_city, 
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(*) AS total_orders
FROM sharan-dsml-sql.business_case_retail.customers c
JOIN sharan-dsml-sql.business_case_retail.orders o 
    ON c.customer_id = o.customer_id
GROUP BY customer_state, customer_city
ORDER BY total_customers DESC
LIMIT 20;

/*
Business Insight:
- Identifies core markets by customer concentration
- Helps in logistics planning and regional retailing
- Reveals geographic market penetration
*/


-- ==========================================
-- 1.4 Overall Dataset Summary
-- ==========================================

SELECT 
    'Total Orders' AS metric,
    CAST(COUNT(*) AS STRING) AS value
FROM sharan-dsml-sql.business_case_retail.orders

UNION ALL

SELECT 
    'Total Customers',
    CAST(COUNT(DISTINCT customer_id) AS STRING)
FROM sharan-dsml-sql.business_case_retail.customers

UNION ALL

SELECT 
    'Total Sellers',
    CAST(COUNT(*) AS STRING)
FROM sharan-dsml-sql.business_case_retail.sellers

UNION ALL

SELECT 
    'Total Products',
    CAST(COUNT(*) AS STRING)
FROM sharan-dsml-sql.business_case_retail.products

UNION ALL

SELECT 
    'Total Reviews',
    CAST(COUNT(*) AS STRING)
FROM sharan-dsml-sql.business_case_retail.reviews;

/*
Business Insight:
- Provides quick snapshot of dataset size
- Helps validate data completeness
- Baseline metrics for analysis
*/


-- ==========================================
-- 1.5 Order Status Distribution
-- ==========================================

SELECT 
    order_status,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM sharan-dsml-sql.business_case_retail.orders
GROUP BY order_status
ORDER BY total_orders DESC;

/*
Business Insight:
- Shows fulfillment success rate
- Identifies potential issues (cancelled, unavailable orders)
- Helps in process optimization
*/


-- ==========================================
-- 1.6 Top 10 Product Categories
-- ==========================================

SELECT 
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(oi.order_item_id) AS total_items,
    ROUND(AVG(oi.price), 2) AS avg_price
FROM sharan-dsml-sql.business_case_retail.products p
JOIN sharan-dsml-sql.business_case_retail.order_items oi
    ON p.product_id = oi.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY total_orders DESC
LIMIT 10;

/*
Business Insight:
- Identifies best-selling product categories
- Helps in inventory management
- Guides marketing focus areas
*/


-- ==========================================
-- END OF EXPLORATORY ANALYSIS
-- ==========================================
