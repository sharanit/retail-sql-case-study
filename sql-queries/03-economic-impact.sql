-- ==========================================
-- 03. ECONOMIC IMPACT ANALYSIS
-- ==========================================
-- Author: [Your Name]
-- Date: February 2026
-- Description: Revenue, pricing, and economic metrics analysis
-- ==========================================

-- ==========================================
-- 3.1 Year-over-Year Revenue Growth (Jan-Aug)
-- ==========================================

WITH payments_2017 AS (
    SELECT SUM(p.payment_value) AS total_payment_2017
    FROM sharan-dsml-sql.business_case_retail.payments p
    JOIN sharan-dsml-sql.business_case_retail.orders o 
        ON p.order_id = o.order_id
    WHERE EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2017
        AND EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 8
),
payments_2018 AS (
    SELECT SUM(p.payment_value) AS total_payment_2018
    FROM sharan-dsml-sql.business_case_retail.payments p
    JOIN sharan-dsml-sql.business_case_retail.orders o 
        ON p.order_id = o.order_id
    WHERE EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2018
        AND EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 8
)
SELECT
    ROUND(total_payment_2017, 2) AS total_payment_2017,
    ROUND(total_payment_2018, 2) AS total_payment_2018,
    ROUND((total_payment_2018 - total_payment_2017), 2) AS absolute_increase,
    ROUND(((total_payment_2018 - total_payment_2017) / total_payment_2017) * 100, 2) AS percentage_increase
FROM payments_2017, payments_2018;

/*
Key Findings:
- 2017 Revenue (Jan-Aug): R$ 3,669,022.12
- 2018 Revenue (Jan-Aug): R$ 8,694,733.84
- Growth: R$ 5,025,711.72 (136.98%)

Business Insight:
- Massive revenue growth indicates successful business expansion
- More than doubled revenue year-over-year
- Strong customer adoption and increased spending
*/


-- ==========================================
-- 3.2 Total & Average Order Value by State
-- ==========================================

SELECT 
    c.customer_state,
    c.customer_city,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_order_value,
    ROUND(AVG(p.payment_value), 2) AS average_order_value,
    ROUND(MIN(p.payment_value), 2) AS min_order_value,
    ROUND(MAX(p.payment_value), 2) AS max_order_value
FROM sharan-dsml-sql.business_case_retail.orders o
JOIN sharan-dsml-sql.business_case_retail.payments p
    ON o.order_id = p.order_id
JOIN sharan-dsml-sql.business_case_retail.customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state, c.customer_city
ORDER BY total_order_value DESC
LIMIT 20;

/*
Key Findings:
- São Paulo dominates in total revenue
- Higher average order values in major metropolitan areas
- Significant variation between states

Business Insight:
- Focus marketing on high-value customer regions
- Opportunity to increase AOV in lower-spending regions
- Tailor product offerings to regional preferences
*/


-- ==========================================
-- 3.3 Monthly Revenue Trends
-- ==========================================

SELECT 
    EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue,
    ROUND(AVG(p.payment_value), 2) AS avg_order_value
FROM sharan-dsml-sql.business_case_retail.orders o
JOIN sharan-dsml-sql.business_case_retail.payments p
    ON o.order_id = p.order_id
GROUP BY year, month
ORDER BY year, month;

/*
Business Insight:
- Identifies revenue seasonality patterns
- Helps in cash flow forecasting
- Guides promotional calendar planning
*/


-- ==========================================
-- 3.4 Product Price Analysis
-- ==========================================

SELECT 
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(AVG(oi.price), 2) AS avg_product_price,
    ROUND(MIN(oi.price), 2) AS min_price,
    ROUND(MAX(oi.price), 2) AS max_price,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM sharan-dsml-sql.business_case_retail.order_items oi
JOIN sharan-dsml-sql.business_case_retail.products p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 15;

/*
Business Insight:
- Identifies most profitable product categories
- Shows price ranges across categories
- Guides pricing strategy
*/


-- ==========================================
-- 3.5 Freight Cost Analysis by State
-- ==========================================

SELECT 
    c.customer_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.freight_value), 2) AS total_freight_cost,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight_per_order,
    ROUND(SUM(oi.price), 2) AS total_product_value,
    ROUND((SUM(oi.freight_value) / SUM(oi.price)) * 100, 2) AS freight_percentage_of_price
FROM sharan-dsml-sql.business_case_retail.order_items oi
JOIN sharan-dsml-sql.business_case_retail.orders o
    ON oi.order_id = o.order_id
JOIN sharan-dsml-sql.business_case_retail.customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY avg_freight_per_order DESC;

/*
Business Insight:
- Identifies states with highest shipping costs
- Shows freight as % of product price
- Helps optimize logistics network
*/


-- ==========================================
-- 3.6 Top 10 Highest Value Orders
-- ==========================================

SELECT 
    o.order_id,
    c.customer_city,
    c.customer_state,
    DATE(o.order_purchase_timestamp) AS order_date,
    ROUND(SUM(p.payment_value), 2) AS total_order_value,
    COUNT(oi.order_item_id) AS total_items
FROM sharan-dsml-sql.business_case_retail.orders o
JOIN sharan-dsml-sql.business_case_retail.payments p
    ON o.order_id = p.order_id
JOIN sharan-dsml-sql.business_case_retail.customers c
    ON o.customer_id = c.customer_id
LEFT JOIN sharan-dsml-sql.business_case_retail.order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id, c.customer_city, c.customer_state, order_date
ORDER BY total_order_value DESC
LIMIT 10;

/*
Business Insight:
- Identifies VIP customers
- Shows high-value transaction patterns
- Guides premium customer retention strategies
*/


-- ==========================================
-- 3.7 Revenue Contribution by State
-- ==========================================

WITH state_revenue AS (
    SELECT 
        c.customer_state,
        ROUND(SUM(p.payment_value), 2) AS total_revenue
    FROM sharan-dsml-sql.business_case_retail.orders o
    JOIN sharan-dsml-sql.business_case_retail.payments p
        ON o.order_id = p.order_id
    JOIN sharan-dsml-sql.business_case_retail.customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_state
)
SELECT 
    customer_state,
    total_revenue,
    ROUND((total_revenue / SUM(total_revenue) OVER()) * 100, 2) AS revenue_percentage,
    SUM(ROUND((total_revenue / SUM(total_revenue) OVER()) * 100, 2)) OVER (
        ORDER BY total_revenue DESC
    ) AS cumulative_percentage
FROM state_revenue
ORDER BY total_revenue DESC;

/*
Business Insight:
- Shows concentration of revenue by state
- Identifies Pareto principle (80/20 rule)
- Guides resource allocation decisions
*/


-- ==========================================
-- END OF ECONOMIC IMPACT ANALYSIS
-- ==========================================
