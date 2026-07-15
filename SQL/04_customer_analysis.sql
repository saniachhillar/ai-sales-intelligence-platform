/*==============================================================================
 OLIST E-COMMERCE ANALYTICS PROJECT
 File: 04_customer_analysis.sql

 Purpose:
 Analyze customer behavior, spending patterns, repeat purchases,
 and geographical distribution.

 Author: Sania
==============================================================================*/


/*==============================================================================
Query 1
Business Question:
How many unique customers are present?
==============================================================================*/

SELECT
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;



/*==============================================================================
Query 2
Business Question:
Which states have the highest number of customers?
==============================================================================*/

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;



/*==============================================================================
Query 3
Business Question:
Which cities have the highest number of customers?
==============================================================================*/

SELECT
    customer_city,
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 20;



/*==============================================================================
Query 4
Business Question:
Which customers have placed the highest number of orders?
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
Query 5
Business Question:
How many repeat customers does the marketplace have?
==============================================================================*/

SELECT
    COUNT(*) AS repeat_customers
FROM
(
    SELECT
        c.customer_unique_id
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) > 1
);



/*==============================================================================
Query 6
Business Question:
Which customers spent the most money?
==============================================================================*/

SELECT
    c.customer_unique_id,
    ROUND(SUM(p.payment_value),2) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN payments p
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 20;



/*==============================================================================
Query 7
Business Question:
What is the average customer lifetime value?
==============================================================================*/

SELECT
    ROUND(AVG(customer_spending),2) AS average_customer_lifetime_value
FROM
(
    SELECT
        c.customer_unique_id,
        SUM(p.payment_value) AS customer_spending
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN payments p
    ON o.order_id = p.order_id
    GROUP BY c.customer_unique_id
);



/*==============================================================================
Query 8
Business Question:
Which customer states generated the highest revenue?
==============================================================================*/

SELECT
    c.customer_state,
    ROUND(SUM(p.payment_value),2) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN payments p
ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;



/*==============================================================================
Query 9
Business Question:
What is the average order value for each customer?
==============================================================================*/

SELECT
    c.customer_unique_id,
    ROUND(AVG(p.payment_value),2) AS average_order_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN payments p
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY average_order_value DESC
LIMIT 20;



/*==============================================================================
Query 10
Business Question:
Which customers placed the largest single order?
==============================================================================*/

SELECT
    c.customer_unique_id,
    o.order_id,
    ROUND(SUM(p.payment_value),2) AS order_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN payments p
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id,
         o.order_id
ORDER BY order_value DESC
LIMIT 20;



/*==============================================================================
Query 11
Business Question:
How many customers belong to each state?
==============================================================================*/

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS customer_count
FROM customers
GROUP BY customer_state
ORDER BY customer_count DESC;



/*==============================================================================
Query 12
Business Question:
What percentage of customers are repeat customers?
==============================================================================*/

SELECT
ROUND(
100.0 *
COUNT(*) /
(
SELECT COUNT(DISTINCT customer_unique_id)
FROM customers
),
2
) AS repeat_customer_percentage

FROM
(
SELECT
c.customer_unique_id

FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id

GROUP BY c.customer_unique_id

HAVING COUNT(o.order_id)>1
);



/*==============================================================================
Query 13
Business Question:
Which customers have placed exactly one order?
==============================================================================*/

SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id)=1
LIMIT 20;



/*==============================================================================
Query 14
Business Question:
Which cities generate the highest revenue?
==============================================================================*/

SELECT
    c.customer_city,
    ROUND(SUM(p.payment_value),2) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN payments p
ON o.order_id=p.order_id
GROUP BY c.customer_city
ORDER BY revenue DESC
LIMIT 20;



/*==============================================================================
Query 15
Business Question:
Which states have the highest average customer spending?
==============================================================================*/

SELECT
    customer_state,
    ROUND(AVG(total_spending),2) AS avg_customer_spending
FROM
(
SELECT
    c.customer_state,
    c.customer_unique_id,
    SUM(p.payment_value) AS total_spending
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN payments p
ON o.order_id=p.order_id
GROUP BY
    c.customer_state,
    c.customer_unique_id
)
GROUP BY customer_state
ORDER BY avg_customer_spending DESC;



/*==============================================================================
End of File
==============================================================================*/