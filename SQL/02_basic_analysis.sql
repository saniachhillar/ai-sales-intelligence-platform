/*==============================================================================
 OLIST E-COMMERCE ANALYTICS PROJECT
 File: 02_basic_analysis.sql

 Purpose:
 This file answers fundamental business questions about the marketplace,
 including order volume, customers, sellers, products, and order trends.

 Author: Sania
==============================================================================*/


/*==============================================================================
Query 1
Business Question:
How many orders are present in the marketplace?
==============================================================================*/

SELECT
    COUNT(*) AS total_orders
FROM orders;



/*==============================================================================
Query 2
Business Question:
How many unique customers have placed orders?
==============================================================================*/

SELECT
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;



/*==============================================================================
Query 3
Business Question:
How many sellers are registered?
==============================================================================*/

SELECT
    COUNT(*) AS total_sellers
FROM sellers;



/*==============================================================================
Query 4
Business Question:
How many products are listed on the marketplace?
==============================================================================*/

SELECT
    COUNT(*) AS total_products
FROM products;



/*==============================================================================
Query 5
Business Question:
How many unique product categories are available?
==============================================================================*/

SELECT
    COUNT(DISTINCT product_category_name) AS total_categories
FROM products;



/*==============================================================================
Query 6
Business Question:
What is the distribution of order statuses?
==============================================================================*/

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;



/*==============================================================================
Query 7
Business Question:
What time period does the dataset cover?
==============================================================================*/

SELECT
    MIN(order_purchase_timestamp) AS first_order_date,
    MAX(order_purchase_timestamp) AS last_order_date
FROM orders;



/*==============================================================================
Query 8
Business Question:
How many orders were placed each year?
==============================================================================*/

SELECT
    strftime('%Y', order_purchase_timestamp) AS purchase_year,
    COUNT(*) AS total_orders
FROM orders
GROUP BY purchase_year
ORDER BY purchase_year;



/*==============================================================================
Query 9
Business Question:
How many orders were placed each month?
==============================================================================*/

SELECT
    strftime('%Y-%m', order_purchase_timestamp) AS purchase_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY purchase_month
ORDER BY purchase_month;



/*==============================================================================
Query 10
Business Question:
Which customer states generated the highest number of orders?
==============================================================================*/

SELECT
    c.customer_state,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;



/*==============================================================================
Query 11
Business Question:
Which customer cities generated the highest number of orders?
==============================================================================*/

SELECT
    c.customer_city,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_city
ORDER BY total_orders DESC
LIMIT 20;



/*==============================================================================
Query 12
Business Question:
What is the average number of orders placed per customer?
==============================================================================*/

SELECT
    ROUND(
        COUNT(order_id) * 1.0 /
        COUNT(DISTINCT customer_id),
        2
    ) AS average_orders_per_customer
FROM orders;



/*==============================================================================
Query 13
Business Question:
How many orders does each customer place?
==============================================================================*/

SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY total_orders DESC
LIMIT 20;



/*==============================================================================
Query 14
Business Question:
How many orders were placed on each day of the week?
==============================================================================*/

SELECT
    CASE strftime('%w', order_purchase_timestamp)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS weekday,

    COUNT(*) AS total_orders

FROM orders

GROUP BY weekday

ORDER BY total_orders DESC;



/*==============================================================================
Query 15
Business Question:
How many orders were placed during each hour of the day?
==============================================================================*/

SELECT

    strftime('%H', order_purchase_timestamp) AS purchase_hour,

    COUNT(*) AS total_orders

FROM orders

GROUP BY purchase_hour

ORDER BY purchase_hour;



/*==============================================================================
End of File
==============================================================================*/