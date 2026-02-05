-- ==========================================
-- 04. DELIVERY PERFORMANCE ANALYSIS
-- ==========================================
-- Author: [Your Name]
-- Date: February 2026
-- Description: Delivery time, freight, and logistics analysis
-- ==========================================

-- ==========================================
-- 4.1 Delivery Time Calculation
-- ==========================================

SELECT 
    o.order_id,
    o.customer_id,
    c.customer_state,
    c.customer_city,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    DATE_DIFF(
        DATE(o.order_delivered_customer_date), 
        DATE(o.order_purchase_timestamp), 
        DAY
    ) AS time_to_deliver,
    DATE_DIFF(
        DATE(o.order_delivered_customer_date), 
        DATE(o.order_estimated_delivery_date), 
        DAY
    ) AS diff_estimated_delivery,
    CASE 
        WHEN DATE_DIFF(DATE(o.order_delivered_customer_date), DATE(o.order_estimated_delivery_date), DAY) < 0 
        THEN 'Early'
        WHEN DATE_DIFF(DATE(o.order_delivered_customer_date), DATE(o.order_estimated_delivery_date), DAY) = 0 
        THEN 'On Time'
        ELSE 'Delayed'
    END AS delivery_status
FROM sharan-dsml-sql.business_case_retail.orders o
JOIN sharan-dsml-sql.business_case_retail.customers c
    ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
    AND o.order_purchase_timestamp IS NOT NULL
    AND o.order_estimated_delivery_date IS NOT NULL
ORDER BY time_to_deliver DESC
LIMIT 100;

/*
Business Insight:
- Calculate actual delivery time vs estimated
- Identify early, on-time, and delayed deliveries
- Track delivery performance metrics
*/


-- ==========================================
-- 4.2 Average Delivery Time by State & City
-- ==========================================

SELECT 
    c.customer_state,
    c.customer_city,
    COUNT(*) AS total_deliveries,
    ROUND(AVG(DATE_DIFF(
        DATE(o.order_delivered_customer_date), 
        DATE(o.order_purchase_timestamp), 
        DAY
    )), 2) AS avg_delivery_time_days,
    ROUND(MIN(DATE_DIFF(
        DATE(o.order_delivered_customer_date), 
        DATE(o.order_purchase_timestamp), 
        DAY
    )), 2) AS min_delivery_time,
    ROUND(MAX(DATE_DIFF(
        DATE(o.order_delivered_customer_date), 
        DATE(o.order_purchase_timestamp), 
        DAY
    )), 2) AS max_delivery_time
FROM sharan-dsml-sql.business_case_retail.orders o
JOIN sharan-dsml-sql.business_case_retail.customers c
    ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
    AND o.order_purchase_timestamp IS NOT NULL
GROUP BY c.customer_state, c.customer_city
ORDER BY avg_delivery_time_days DESC
LIMIT 20;

/*
Key Findings:
- Northeast regions (MA, PB, RN, BA) show 42-45 days avg delivery time
- Major cities show better delivery performance
- Remote areas face logistical challenges

Business Insight:
- Identify regions needing logistics improvement
- Set realistic delivery expectations by region
- retail infrastructure investments
*/


-- ==========================================
-- 4.3 Top 5 States - Highest & Lowest Freight
-- ==========================================

WITH state_freight_avg AS (
    SELECT 
        c.customer_state,
        c.customer_city,
        ROUND(AVG(oi.freight_value), 2) AS average_freight_value,
        COUNT(DISTINCT oi.order_id) AS total_orders
    FROM sharan-dsml-sql.business_case_retail.order_items oi
    JOIN sharan-dsml-sql.business_case_retail.orders o
        ON oi.order_id = o.order_id
    JOIN sharan-dsml-sql.business_case_retail.customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_state, c.customer_city
    HAVING average_freight_value IS NOT NULL
)
(
    SELECT 
        'Top 5 Highest' AS category,
        customer_state,
        customer_city,
        average_freight_value,
        total_orders
    FROM state_freight_avg
    ORDER BY average_freight_value DESC
    LIMIT 5
)
UNION ALL
(
    SELECT 
        'Top 5 Lowest' AS category,
        customer_state,
        customer_city,
        average_freight_value,
        total_orders
    FROM state_freight_avg
    ORDER BY average_freight_value ASC
    LIMIT 5
);

/*
Business Insight:
- Identifies regions with highest shipping costs
- Shows cost variation across geography
- Helps negotiate carrier contracts by region
*/


-- ==========================================
-- 4.4 Top 5 States - Fastest & Slowest Delivery
-- ==========================================

WITH state_delivery_avg AS (
    SELECT 
        c.customer_state,
        c.customer_city,
        ROUND(AVG(DATE_DIFF(
            DATE(o.order_delivered_customer_date), 
            DATE(o.order_purchase_timestamp), 
            DAY
        )), 2) AS average_delivery_time_days,
        COUNT(*) AS total_deliveries
    FROM sharan-dsml-sql.business_case_retail.orders o
    JOIN sharan-dsml-sql.business_case_retail.customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_delivered_customer_date IS NOT NULL
        AND o.order_purchase_timestamp IS NOT NULL
    GROUP BY c.customer_state, c.customer_city
)
(
    SELECT 
        'Top 5 Slowest' AS category,
        customer_state,
        customer_city,
        average_delivery_time_days,
        total_deliveries
    FROM state_delivery_avg
    ORDER BY average_delivery_time_days DESC
    LIMIT 5
)
UNION ALL
(
    SELECT 
        'Top 5 Fastest' AS category,
        customer_state,
        customer_city,
        average_delivery_time_days,
        total_deliveries
    FROM state_delivery_avg
    ORDER BY average_delivery_time_days ASC
    LIMIT 5
);

/*
Business Insight:
- Benchmark delivery performance across regions
- Identify best and worst performing areas
- Learn from fast-delivery regions
*/


-- ==========================================
-- 4.5 States with Faster-than-Estimated Delivery
-- ==========================================

WITH state_delivery_comparison AS (
    SELECT 
        c.customer_state,
        c.customer_city,
        ROUND(AVG(DATE_DIFF(
            DATE(o.order_delivered_customer_date), 
            DATE(o.order_estimated_delivery_date), 
            DAY
        )), 2) AS avg_diff_actual_vs_estimated_days,
        COUNT(*) AS total_orders,
        SUM(CASE WHEN DATE_DIFF(
            DATE(o.order_delivered_customer_date), 
            DATE(o.order_estimated_delivery_date), 
            DAY
        ) < 0 THEN 1 ELSE 0 END) AS early_deliveries
    FROM sharan-dsml-sql.business_case_retail.orders o
    JOIN sharan-dsml-sql.business_case_retail.customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_delivered_customer_date IS NOT NULL
        AND o.order_estimated_delivery_date IS NOT NULL
    GROUP BY c.customer_state, c.customer_city
)
SELECT 
    customer_state,
    customer_city,
    avg_diff_actual_vs_estimated_days,
    total_orders,
    early_deliveries,
    ROUND((early_deliveries * 100.0 / total_orders), 2) AS early_delivery_percentage
FROM state_delivery_comparison
ORDER BY avg_diff_actual_vs_estimated_days ASC
LIMIT 10;

/*
Key Findings:
- Negative values indicate early delivery
- Positive values indicate delays

Business Insight:
- Celebrate and replicate success factors
- Improve estimation accuracy
- Enhance customer satisfaction
*/


-- ==========================================
-- 4.6 Delivery Performance Over Time
-- ==========================================

SELECT 
    EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
    COUNT(*) AS total_deliveries,
    ROUND(AVG(DATE_DIFF(
        DATE(o.order_delivered_customer_date), 
        DATE(o.order_purchase_timestamp), 
        DAY
    )), 2) AS avg_delivery_days,
    SUM(CASE 
        WHEN DATE_DIFF(DATE(o.order_delivered_customer_date), DATE(o.order_estimated_delivery_date), DAY) <= 0 
        THEN 1 ELSE 0 
    END) AS on_time_or_early,
    ROUND((SUM(CASE 
        WHEN DATE_DIFF(DATE(o.order_delivered_customer_date), DATE(o.order_estimated_delivery_date), DAY) <= 0 
        THEN 1 ELSE 0 
    END) * 100.0 / COUNT(*)), 2) AS on_time_percentage
FROM sharan-dsml-sql.business_case_retail.orders o
WHERE o.order_delivered_customer_date IS NOT NULL
    AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY year, month
ORDER BY year, month;

/*
Business Insight:
- Track delivery performance improvement over time
- Identify seasonal patterns in delivery times
- Monitor service level agreements (SLA)
*/


-- ==========================================
-- 4.7 Carrier Performance (if carrier data available)
-- ==========================================

SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(DATE_DIFF(
        DATE(o.order_delivered_carrier_date), 
        DATE(o.order_purchase_timestamp), 
        DAY
    )), 2) AS avg_days_to_carrier,
    ROUND(AVG(DATE_DIFF(
        DATE(o.order_delivered_customer_date), 
        DATE(o.order_delivered_carrier_date), 
        DAY
    )), 2) AS avg_days_carrier_to_customer
FROM sharan-dsml-sql.business_case_retail.orders o
JOIN sharan-dsml-sql.business_case_retail.customers c
    ON o.customer_id = c.customer_id
WHERE o.order_delivered_carrier_date IS NOT NULL
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_days_carrier_to_customer DESC
LIMIT 15;

/*
Business Insight:
- Separate internal processing time vs carrier delivery time
- Identify bottlenecks in fulfillment chain
- Optimize warehouse-to-carrier handoff
*/


-- ==========================================
-- END OF DELIVERY PERFORMANCE ANALYSIS
-- ==========================================
