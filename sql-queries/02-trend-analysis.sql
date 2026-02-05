-- ==========================================
-- 02. TREND ANALYSIS
-- ==========================================
-- Author: [Your Name]
-- Date: February 2026
-- Description: Growth trends and seasonal patterns analysis
-- ==========================================

-- ==========================================
-- 2.1 Year-over-Year Order Growth
-- ==========================================

SELECT 
    EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
    COUNT(*) AS total_orders,
    LAG(COUNT(*)) OVER (ORDER BY EXTRACT(YEAR FROM order_purchase_timestamp)) AS previous_year_orders,
    ROUND(
        (COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY EXTRACT(YEAR FROM order_purchase_timestamp))) * 100.0 
        / NULLIF(LAG(COUNT(*)) OVER (ORDER BY EXTRACT(YEAR FROM order_purchase_timestamp)), 0),
        2
    ) AS growth_percentage
FROM sharan-dsml-sql.business_case_retail.orders
GROUP BY year
ORDER BY year;

/*
Key Findings:
- 2016: 329 orders (baseline)
- 2017: 45,101 orders (13,608% growth)
- 2018: 54,011 orders (19.8% growth)

Business Insight:
- Explosive growth in 2017 indicates successful market entry
- Continued growth in 2018 shows sustained momentum
- Company successfully scaling operations year-over-year
*/


-- ==========================================
-- 2.2 Monthly Seasonality Analysis
-- ==========================================

SELECT 
    EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
    FORMAT_DATE('%B', DATE(order_purchase_timestamp)) AS month_name,
    COUNT(*) AS total_orders,
    ROUND(AVG(COUNT(*)) OVER(), 0) AS avg_monthly_orders,
    CASE 
        WHEN COUNT(*) > AVG(COUNT(*)) OVER() THEN 'Above Average'
        ELSE 'Below Average'
    END AS performance
FROM sharan-dsml-sql.business_case_retail.orders
GROUP BY month, month_name
ORDER BY month;

/*
Key Findings:
- Peak months: March-August (9,893 - 10,843 orders)
- August is highest: 10,843 orders
- Low months: September (4,305), October (4,959)
- December surprisingly low: 5,674 orders

Business Insight:
- Clear seasonal pattern: High activity Mar-Aug, Low Sep-Oct
- Summer months drive highest sales
- Opportunity to boost sales in low months with promotions
*/


-- ==========================================
-- 2.3 Quarter-wise Order Distribution
-- ==========================================

SELECT 
    EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
    EXTRACT(QUARTER FROM order_purchase_timestamp) AS quarter,
    COUNT(*) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM sharan-dsml-sql.business_case_retail.orders o
JOIN sharan-dsml-sql.business_case_retail.payments p
    ON o.order_id = p.order_id
GROUP BY year, quarter
ORDER BY year, quarter;

/*
Business Insight:
- Identifies quarterly performance trends
- Helps in quarterly forecasting
- Seasonal business planning
*/


-- ==========================================
-- 2.4 Time of Day Analysis
-- ==========================================

SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 0 AND 6 THEN 'Dawn (12-6 AM)'
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 7 AND 12 THEN 'Morning (7 AM-12 PM)'
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 13 AND 18 THEN 'Afternoon (1-6 PM)'
        ELSE 'Night (7-11 PM)'
    END AS time_of_day,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM sharan-dsml-sql.business_case_retail.orders
GROUP BY time_of_day
ORDER BY total_orders DESC;

/*
Key Findings:
- Afternoon (1-6 PM): 38,135 orders (38.4%)
- Night (7-11 PM): 28,331 orders (28.5%)
- Morning (7 AM-12 PM): 27,733 orders (27.9%)
- Dawn (12-6 AM): 5,242 orders (5.2%)

Business Insight:
- Peak shopping time: Afternoon and Evening
- Optimize marketing campaigns for 1-11 PM window
- Customer support should be prioritized during peak hours
*/


-- ==========================================
-- 2.5 Hourly Order Pattern
-- ==========================================

SELECT 
    EXTRACT(HOUR FROM order_purchase_timestamp) AS hour,
    COUNT(*) AS total_orders,
    ROUND(AVG(p.payment_value), 2) AS avg_order_value
FROM sharan-dsml-sql.business_case_retail.orders o
LEFT JOIN sharan-dsml-sql.business_case_retail.payments p
    ON o.order_id = p.order_id
GROUP BY hour
ORDER BY hour;

/*
Business Insight:
- Granular view of customer activity throughout the day
- Helps optimize flash sales timing
- Identifies peak load hours for system capacity planning
*/


-- ==========================================
-- 2.6 Day of Week Analysis
-- ==========================================

SELECT 
    EXTRACT(DAYOFWEEK FROM order_purchase_timestamp) AS day_of_week,
    FORMAT_DATE('%A', DATE(order_purchase_timestamp)) AS day_name,
    COUNT(*) AS total_orders,
    ROUND(AVG(p.payment_value), 2) AS avg_order_value
FROM sharan-dsml-sql.business_case_retail.orders o
LEFT JOIN sharan-dsml-sql.business_case_retail.payments p
    ON o.order_id = p.order_id
GROUP BY day_of_week, day_name
ORDER BY day_of_week;

/*
Business Insight:
- Identifies which days customers prefer to shop
- Helps plan weekly promotions
- Guides logistics and staffing schedules
*/


-- ==========================================
-- 2.7 Month-on-Month Growth by State
-- ==========================================

SELECT 
    EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
    c.customer_state,
    COUNT(*) AS total_orders,
    LAG(COUNT(*)) OVER (
        PARTITION BY c.customer_state 
        ORDER BY EXTRACT(YEAR FROM o.order_purchase_timestamp), 
                 EXTRACT(MONTH FROM o.order_purchase_timestamp)
    ) AS previous_month_orders
FROM sharan-dsml-sql.business_case_retail.orders o
JOIN sharan-dsml-sql.business_case_retail.customers c
    ON o.customer_id = c.customer_id
GROUP BY year, month, c.customer_state
ORDER BY c.customer_state, year, month;

/*
Business Insight:
- Track regional growth patterns
- Identify emerging markets
- retail underperforming regions
*/


-- ==========================================
-- END OF TREND ANALYSIS
-- ==========================================
