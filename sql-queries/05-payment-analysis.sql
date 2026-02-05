-- ==========================================
-- 05. PAYMENT BEHAVIOR ANALYSIS
-- ==========================================
-- Author: [Your Name]
-- Date: February 2026
-- Description: Payment methods, installments, and transaction analysis
-- ==========================================

-- ==========================================
-- 5.1 Month-on-Month Orders by Payment Type
-- ==========================================

SELECT 
    EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS order_month,
    p.payment_type,
    COUNT(DISTINCT o.order_id) AS num_orders,
    ROUND(SUM(p.payment_value), 2) AS total_payment_value,
    ROUND(AVG(p.payment_value), 2) AS avg_payment_value
FROM sharan-dsml-sql.business_case_retail.orders o
JOIN sharan-dsml-sql.business_case_retail.payments p
    ON o.order_id = p.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY year, order_month, p.payment_type
ORDER BY year, order_month, num_orders DESC;

/*
Business Insight:
- Track payment method preferences over time
- Identify most popular payment methods
- Guide payment gateway optimization
*/


-- ==========================================
-- 5.2 Payment Type Distribution
-- ==========================================

SELECT 
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(COUNT(DISTINCT order_id) * 100.0 / SUM(COUNT(DISTINCT order_id)) OVER(), 2) AS order_percentage,
    ROUND(SUM(payment_value), 2) AS total_value,
    ROUND(AVG(payment_value), 2) AS avg_transaction_value,
    ROUND(MIN(payment_value), 2) AS min_value,
    ROUND(MAX(payment_value), 2) AS max_value
FROM sharan-dsml-sql.business_case_retail.payments
GROUP BY payment_type
ORDER BY total_orders DESC;

/*
Business Insight:
- Shows customer payment preferences
- Identifies most valuable payment methods
- Helps prioritize payment gateway partnerships
*/


-- ==========================================
-- 5.3 Orders by Payment Installments
-- ==========================================

SELECT 
    p.payment_installments,
    COUNT(DISTINCT o.order_id) AS num_orders,
    ROUND(COUNT(DISTINCT o.order_id) * 100.0 / SUM(COUNT(DISTINCT o.order_id)) OVER(), 2) AS percentage,
    ROUND(SUM(p.payment_value), 2) AS total_payment_value,
    ROUND(AVG(p.payment_value), 2) AS avg_order_value,
    ROUND(AVG(p.payment_value) / p.payment_installments, 2) AS avg_installment_amount
FROM sharan-dsml-sql.business_case_retail.orders o
JOIN sharan-dsml-sql.business_case_retail.payments p
    ON o.order_id = p.order_id
GROUP BY p.payment_installments
ORDER BY p.payment_installments ASC;

/*
Key Findings:
- Most common: 1 installment (lump sum payment)
- Installment usage indicates customer financing needs
- Higher installments for higher-value orders

Business Insight:
- Popular installment plans indicate affordability concerns
- Optimize installment offerings (3, 6, 12 months)
- Partner with financing providers for flexible options
*/


-- ==========================================
-- 5.4 Payment Value Analysis by State
-- ==========================================

SELECT 
    c.customer_state,
    COUNT(DISTINCT p.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_payment_value,
    ROUND(AVG(p.payment_value), 2) AS avg_payment_per_order,
    ROUND(AVG(p.payment_installments), 2) AS avg_installments,
    p.payment_type AS most_used_payment_type
FROM sharan-dsml-sql.business_case_retail.payments p
JOIN sharan-dsml-sql.business_case_retail.orders o
    ON p.order_id = o.order_id
JOIN sharan-dsml-sql.business_case_retail.customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state, p.payment_type
QUALIFY ROW_NUMBER() OVER (PARTITION BY c.customer_state ORDER BY COUNT(*) DESC) = 1
ORDER BY total_payment_value DESC;

/*
Business Insight:
- Regional payment behavior patterns
- State-wise spending capacity
- Tailor payment options by region
*/


-- ==========================================
-- 5.5 Multi-Payment Orders Analysis
-- ==========================================

WITH payment_counts AS (
    SELECT 
        order_id,
        COUNT(*) AS num_payments,
        SUM(payment_value) AS total_paid
    FROM sharan-dsml-sql.business_case_retail.payments
    GROUP BY order_id
)
SELECT 
    CASE 
        WHEN num_payments = 1 THEN '1 Payment'
        WHEN num_payments = 2 THEN '2 Payments'
        WHEN num_payments = 3 THEN '3 Payments'
        ELSE '4+ Payments'
    END AS payment_count_category,
    COUNT(*) AS num_orders,
    ROUND(AVG(total_paid), 2) AS avg_order_value,
    ROUND(MIN(total_paid), 2) AS min_order_value,
    ROUND(MAX(total_paid), 2) AS max_order_value
FROM payment_counts
GROUP BY payment_count_category
ORDER BY 
    CASE payment_count_category
        WHEN '1 Payment' THEN 1
        WHEN '2 Payments' THEN 2
        WHEN '3 Payments' THEN 3
        ELSE 4
    END;

/*
Business Insight:
- Some orders split across multiple payment methods
- Higher-value orders tend to use multiple payments
- Indicates customer payment flexibility needs
*/


-- ==========================================
-- 5.6 Payment Sequential Analysis
-- ==========================================

SELECT 
    payment_sequential,
    COUNT(DISTINCT order_id) AS num_orders,
    ROUND(AVG(payment_value), 2) AS avg_payment_value,
    payment_type
FROM sharan-dsml-sql.business_case_retail.payments
WHERE payment_sequential > 1
GROUP BY payment_sequential, payment_type
ORDER BY payment_sequential, num_orders DESC;

/*
Business Insight:
- Track orders with sequential/split payments
- Understand payment plan usage
- Identify complex payment scenarios
*/


-- ==========================================
-- 5.7 High-Value Transaction Analysis
-- ==========================================

SELECT 
    p.order_id,
    c.customer_state,
    c.customer_city,
    p.payment_type,
    p.payment_installments,
    ROUND(SUM(p.payment_value), 2) AS total_payment,
    COUNT(oi.order_item_id) AS num_items
FROM sharan-dsml-sql.business_case_retail.payments p
JOIN sharan-dsml-sql.business_case_retail.orders o
    ON p.order_id = o.order_id
JOIN sharan-dsml-sql.business_case_retail.customers c
    ON o.customer_id = c.customer_id
LEFT JOIN sharan-dsml-sql.business_case_retail.order_items oi
    ON p.order_id = oi.order_id
GROUP BY p.order_id, c.customer_state, c.customer_city, p.payment_type, p.payment_installments
HAVING SUM(p.payment_value) > 1000
ORDER BY total_payment DESC
LIMIT 50;

/*
Business Insight:
- Identify high-value customers
- Understand premium customer payment preferences
- retail VIP customer retention programs
*/


-- ==========================================
-- 5.8 Payment Type Trends Over Time
-- ==========================================

SELECT 
    EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
    EXTRACT(QUARTER FROM o.order_purchase_timestamp) AS quarter,
    p.payment_type,
    COUNT(DISTINCT p.order_id) AS num_orders,
    ROUND(SUM(p.payment_value), 2) AS total_value,
    ROUND(AVG(p.payment_installments), 2) AS avg_installments
FROM sharan-dsml-sql.business_case_retail.payments p
JOIN sharan-dsml-sql.business_case_retail.orders o
    ON p.order_id = o.order_id
GROUP BY year, quarter, p.payment_type
ORDER BY year, quarter, num_orders DESC;

/*
Business Insight:
- Track evolution of payment preferences
- Identify emerging payment trends
- Adapt to changing customer behavior
*/


-- ==========================================
-- 5.9 Installment Plans by Product Category
-- ==========================================

SELECT 
    pr.product_category_name,
    ROUND(AVG(pa.payment_installments), 2) AS avg_installments,
    ROUND(AVG(pa.payment_value), 2) AS avg_payment_value,
    COUNT(DISTINCT pa.order_id) AS num_orders,
    ROUND(MAX(pa.payment_installments), 0) AS max_installments
FROM sharan-dsml-sql.business_case_retail.payments pa
JOIN sharan-dsml-sql.business_case_retail.order_items oi
    ON pa.order_id = oi.order_id
JOIN sharan-dsml-sql.business_case_retail.products pr
    ON oi.product_id = pr.product_id
WHERE pr.product_category_name IS NOT NULL
GROUP BY pr.product_category_name
ORDER BY avg_installments DESC
LIMIT 20;

/*
Business Insight:
- Expensive categories use more installments
- Category-specific financing needs
- Optimize installment offerings per category
*/


-- ==========================================
-- 5.10 Payment Success Rate Analysis
-- ==========================================

WITH order_status_payments AS (
    SELECT 
        o.order_status,
        p.payment_type,
        COUNT(*) AS num_transactions,
        ROUND(SUM(p.payment_value), 2) AS total_value
    FROM sharan-dsml-sql.business_case_retail.orders o
    JOIN sharan-dsml-sql.business_case_retail.payments p
        ON o.order_id = p.order_id
    GROUP BY o.order_status, p.payment_type
)
SELECT 
    order_status,
    payment_type,
    num_transactions,
    total_value,
    ROUND(num_transactions * 100.0 / SUM(num_transactions) OVER (PARTITION BY payment_type), 2) AS percentage_of_payment_type
FROM order_status_payments
ORDER BY payment_type, num_transactions DESC;

/*
Business Insight:
- Correlate payment methods with order success
- Identify payment-related cancellations
- Optimize payment flow and fraud detection
*/


-- ==========================================
-- END OF PAYMENT BEHAVIOR ANALYSIS
-- ==========================================
