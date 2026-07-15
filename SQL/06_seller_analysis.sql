/*==============================================================================
 OLIST E-COMMERCE ANALYTICS PROJECT
 File: 06_seller_analysis.sql

 Purpose:
 Analyze seller performance, revenue contribution, order volume,
 geographical distribution, and operational metrics.

 Author: Sania
==============================================================================*/


/*==============================================================================
Query 1
Business Question:
Which sellers generated the highest revenue?
==============================================================================*/

SELECT
    seller_id,
    ROUND(SUM(price),2) AS revenue
FROM order_items
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 20;



/*==============================================================================
Query 2
Business Question:
Which sellers fulfilled the highest number of orders?
==============================================================================*/

SELECT
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_items
GROUP BY seller_id
ORDER BY total_orders DESC
LIMIT 20;



/*==============================================================================
Query 3
Business Question:
Which states have the highest number of sellers?
==============================================================================*/

SELECT
    seller_state,
    COUNT(*) AS total_sellers
FROM sellers
GROUP BY seller_state
ORDER BY total_sellers DESC;



/*==============================================================================
Query 4
Business Question:
Which seller states generated the highest revenue?
==============================================================================*/

SELECT
    s.seller_state,
    ROUND(SUM(oi.price),2) AS revenue
FROM sellers s
JOIN order_items oi
ON s.seller_id = oi.seller_id
GROUP BY s.seller_state
ORDER BY revenue DESC;



/*==============================================================================
Query 5
Business Question:
What is the average revenue generated per seller?
==============================================================================*/

SELECT
    ROUND(AVG(revenue),2) AS average_seller_revenue
FROM
(
    SELECT
        seller_id,
        SUM(price) AS revenue
    FROM order_items
    GROUP BY seller_id
);



/*==============================================================================
Query 6
Business Question:
Which sellers charge the highest average freight?
==============================================================================*/

SELECT
    seller_id,
    ROUND(AVG(freight_value),2) AS average_freight
FROM order_items
GROUP BY seller_id
ORDER BY average_freight DESC
LIMIT 20;



/*==============================================================================
Query 7
Business Question:
Which sellers sell the largest variety of products?
==============================================================================*/

SELECT
    seller_id,
    COUNT(DISTINCT product_id) AS unique_products
FROM order_items
GROUP BY seller_id
ORDER BY unique_products DESC
LIMIT 20;



/*==============================================================================
Query 8
Business Question:
Which sellers have the highest average selling price?
==============================================================================*/

SELECT
    seller_id,
    ROUND(AVG(price),2) AS average_product_price
FROM order_items
GROUP BY seller_id
ORDER BY average_product_price DESC
LIMIT 20;



/*==============================================================================
Query 9
Business Question:
Which sellers contributed the highest percentage of total revenue?
==============================================================================*/

SELECT
    seller_id,

    ROUND(SUM(price),2) AS revenue,

    ROUND(
        100.0 * SUM(price) /
        (SELECT SUM(price) FROM order_items),
        2
    ) AS revenue_percentage

FROM order_items

GROUP BY seller_id

ORDER BY revenue DESC
LIMIT 20;



/*==============================================================================
Query 10
Business Question:
How many orders does each seller fulfill on average?
==============================================================================*/

SELECT
    ROUND(AVG(order_count),2) AS average_orders_per_seller
FROM
(
    SELECT
        seller_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM order_items
    GROUP BY seller_id
);



/*==============================================================================
Query 11
Business Question:
Which seller states have the highest average revenue per seller?
==============================================================================*/

SELECT
    seller_state,
    ROUND(AVG(revenue),2) AS avg_revenue
FROM
(
    SELECT
        s.seller_state,
        s.seller_id,
        SUM(oi.price) AS revenue
    FROM sellers s
    JOIN order_items oi
    ON s.seller_id = oi.seller_id
    GROUP BY
        s.seller_state,
        s.seller_id
)
GROUP BY seller_state
ORDER BY avg_revenue DESC;



/*==============================================================================
Query 12
Business Question:
Which sellers receive the highest average review score?
==============================================================================*/

SELECT
    oi.seller_id,
    ROUND(AVG(r.review_score),2) AS average_review
FROM reviews r
JOIN orders o
ON r.order_id = o.order_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY oi.seller_id
ORDER BY average_review DESC
LIMIT 20;



/*==============================================================================
Query 13
Business Question:
Which sellers experience the highest delivery delays?
==============================================================================*/

SELECT
    oi.seller_id,

    ROUND(
        AVG(
            julianday(o.order_delivered_customer_date) -
            julianday(o.order_estimated_delivery_date)
        ),
        2
    ) AS average_delay

FROM order_items oi
JOIN orders o
ON oi.order_id = o.order_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY oi.seller_id

ORDER BY average_delay DESC
LIMIT 20;



/*==============================================================================
Query 14
Business Question:
Which sellers generated the highest revenue per order?
==============================================================================*/

SELECT
    seller_id,

    ROUND(
        SUM(price) /
        COUNT(DISTINCT order_id),
        2
    ) AS revenue_per_order

FROM order_items

GROUP BY seller_id

ORDER BY revenue_per_order DESC
LIMIT 20;



/*==============================================================================
Query 15
Business Question:
Which sellers have the largest average basket size?
==============================================================================*/

SELECT
    seller_id,

    ROUND(
        AVG(items_per_order),
        2
    ) AS average_items_per_order

FROM
(
    SELECT
        seller_id,
        order_id,
        COUNT(*) AS items_per_order
    FROM order_items
    GROUP BY seller_id, order_id
)

GROUP BY seller_id

ORDER BY average_items_per_order DESC
LIMIT 20;



/*==============================================================================
End of File
==============================================================================*/