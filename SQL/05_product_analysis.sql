/*==============================================================================
 OLIST E-COMMERCE ANALYTICS PROJECT
 File: 05_product_analysis.sql

 Purpose:
 Analyze product and category performance, pricing, freight costs,
 and sales contribution.

 Author: Sania
==============================================================================*/


/*==============================================================================
Query 1
Business Question:
Which product categories generated the highest revenue?
==============================================================================*/

SELECT
    pct.product_category_name_english AS category,
    ROUND(SUM(oi.price),2) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN category_translation pct
ON p.product_category_name = pct.product_category_name
GROUP BY category
ORDER BY revenue DESC;



/*==============================================================================
Query 2
Business Question:
Which product categories sold the highest number of items?
==============================================================================*/

SELECT
    pct.product_category_name_english AS category,
    COUNT(*) AS products_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN category_translation pct
ON p.product_category_name = pct.product_category_name
GROUP BY category
ORDER BY products_sold DESC;



/*==============================================================================
Query 3
Business Question:
Which products generated the highest revenue?
==============================================================================*/

SELECT
    product_id,
    ROUND(SUM(price),2) AS revenue
FROM order_items
GROUP BY product_id
ORDER BY revenue DESC
LIMIT 20;



/*==============================================================================
Query 4
Business Question:
Which products were sold the most?
==============================================================================*/

SELECT
    product_id,
    COUNT(*) AS quantity_sold
FROM order_items
GROUP BY product_id
ORDER BY quantity_sold DESC
LIMIT 20;



/*==============================================================================
Query 5
Business Question:
Which categories have the highest average product price?
==============================================================================*/

SELECT
    pct.product_category_name_english AS category,
    ROUND(AVG(oi.price),2) AS average_price
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN category_translation pct
ON p.product_category_name = pct.product_category_name
GROUP BY category
ORDER BY average_price DESC;



/*==============================================================================
Query 6
Business Question:
Which categories have the highest average freight cost?
==============================================================================*/

SELECT
    pct.product_category_name_english AS category,
    ROUND(AVG(oi.freight_value),2) AS average_freight
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN category_translation pct
ON p.product_category_name = pct.product_category_name
GROUP BY category
ORDER BY average_freight DESC;



/*==============================================================================
Query 7
Business Question:
Which categories contain the most products?
==============================================================================*/

SELECT
    pct.product_category_name_english AS category,
    COUNT(*) AS total_products
FROM products p
JOIN category_translation pct
ON p.product_category_name = pct.product_category_name
GROUP BY category
ORDER BY total_products DESC;



/*==============================================================================
Query 8
Business Question:
What is the average product weight by category?
==============================================================================*/

SELECT
    pct.product_category_name_english AS category,
    ROUND(AVG(product_weight_g),2) AS avg_weight
FROM products p
JOIN category_translation pct
ON p.product_category_name = pct.product_category_name
GROUP BY category
ORDER BY avg_weight DESC;



/*==============================================================================
Query 9
Business Question:
Which products have the highest freight charges?
==============================================================================*/

SELECT
    product_id,
    ROUND(AVG(freight_value),2) AS avg_freight
FROM order_items
GROUP BY product_id
ORDER BY avg_freight DESC
LIMIT 20;



/*==============================================================================
Query 10
Business Question:
Which products have the highest selling price?
==============================================================================*/

SELECT
    product_id,
    MAX(price) AS highest_price
FROM order_items
GROUP BY product_id
ORDER BY highest_price DESC
LIMIT 20;



/*==============================================================================
Query 11
Business Question:
What percentage of total revenue does each category contribute?
==============================================================================*/

SELECT
    pct.product_category_name_english AS category,

    ROUND(SUM(oi.price),2) AS revenue,

    ROUND(
        100.0 * SUM(oi.price) /
        (
            SELECT SUM(price)
            FROM order_items
        ),
        2
    ) AS revenue_percentage

FROM order_items oi

JOIN products p
ON oi.product_id = p.product_id

JOIN category_translation pct
ON p.product_category_name = pct.product_category_name

GROUP BY category

ORDER BY revenue DESC;



/*==============================================================================
Query 12
Business Question:
Which categories have the highest average review score?
==============================================================================*/

SELECT
    pct.product_category_name_english AS category,
    ROUND(AVG(r.review_score),2) AS average_review
FROM reviews r
JOIN orders o
ON r.order_id = o.order_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
JOIN category_translation pct
ON p.product_category_name = pct.product_category_name
GROUP BY category
ORDER BY average_review DESC;



/*==============================================================================
Query 13
Business Question:
What is the average number of products purchased per order?
==============================================================================*/

SELECT
    ROUND(AVG(items_per_order),2) AS avg_products_per_order
FROM
(
    SELECT
        order_id,
        COUNT(*) AS items_per_order
    FROM order_items
    GROUP BY order_id
);



/*==============================================================================
Query 14
Business Question:
Which product categories are the most expensive to ship?
==============================================================================*/

SELECT
    pct.product_category_name_english AS category,
    ROUND(AVG(oi.freight_value),2) AS freight_cost
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN category_translation pct
ON p.product_category_name = pct.product_category_name
GROUP BY category
ORDER BY freight_cost DESC
LIMIT 20;



/*==============================================================================
Query 15
Business Question:
Which categories have the highest average product dimensions?
==============================================================================*/

SELECT
    pct.product_category_name_english AS category,

    ROUND(AVG(product_length_cm),2) AS avg_length,

    ROUND(AVG(product_height_cm),2) AS avg_height,

    ROUND(AVG(product_width_cm),2) AS avg_width

FROM products p

JOIN category_translation pct
ON p.product_category_name = pct.product_category_name

GROUP BY category

ORDER BY avg_length DESC;



/*==============================================================================
End of File
==============================================================================*/