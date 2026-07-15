/*==============================================================================
 OLIST E-COMMERCE ANALYTICS PROJECT
 File: 09_advanced_analysis.sql

 Purpose:
 Advanced SQL analysis using CTEs, Window Functions,
 Ranking, Running Totals and Business Analytics.

 Author: Sania
==============================================================================*/


/*==============================================================================
Query 1
Business Question:
Rank product categories by total revenue.
(Window Function)
==============================================================================*/

WITH category_revenue AS
(
SELECT
    pct.product_category_name_english AS category,
    SUM(oi.price) AS revenue

FROM order_items oi

JOIN products p
ON oi.product_id=p.product_id

JOIN category_translation pct
ON p.product_category_name=pct.product_category_name

GROUP BY category
)

SELECT
category,
ROUND(revenue,2) revenue,

RANK() OVER(
ORDER BY revenue DESC
) revenue_rank

FROM category_revenue;



/*==============================================================================
Query 2
Business Question:
Top 3 sellers by revenue.
==============================================================================*/

WITH seller_revenue AS
(
SELECT

seller_id,

SUM(price) revenue

FROM order_items

GROUP BY seller_id
)

SELECT *

FROM seller_revenue

ORDER BY revenue DESC

LIMIT 3;



/*==============================================================================
Query 3
Business Question:
Top 5 customers by spending.
==============================================================================*/

WITH customer_spending AS
(

SELECT

c.customer_unique_id,

SUM(p.payment_value) total_spent

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

JOIN payments p
ON o.order_id=p.order_id

GROUP BY c.customer_unique_id

)

SELECT *

FROM customer_spending

ORDER BY total_spent DESC

LIMIT 5;



/*==============================================================================
Query 4
Business Question:
Running monthly revenue.
==============================================================================*/

WITH monthly_revenue AS
(

SELECT

strftime('%Y-%m',o.order_purchase_timestamp) month,

SUM(p.payment_value) revenue

FROM orders o

JOIN payments p

ON o.order_id=p.order_id

GROUP BY month

)

SELECT

month,

ROUND(revenue,2),

ROUND(

SUM(revenue)

OVER(

ORDER BY month

),

2

) running_revenue

FROM monthly_revenue;



/*==============================================================================
Query 5
Business Question:
Monthly revenue growth.
==============================================================================*/

WITH monthly_revenue AS
(

SELECT

strftime('%Y-%m',order_purchase_timestamp) month,

SUM(payment_value) revenue

FROM orders o

JOIN payments p

ON o.order_id=p.order_id

GROUP BY month

)

SELECT

month,

ROUND(revenue,2),

ROUND(

revenue-

LAG(revenue)

OVER(

ORDER BY month

),

2

) revenue_growth

FROM monthly_revenue;



/*==============================================================================
Query 6
Business Question:
Revenue contribution by category.
==============================================================================*/

WITH category_revenue AS
(

SELECT

pct.product_category_name_english category,

SUM(oi.price) revenue

FROM order_items oi

JOIN products p

ON oi.product_id=p.product_id

JOIN category_translation pct

ON p.product_category_name=pct.product_category_name

GROUP BY category

)

SELECT

category,

ROUND(revenue,2),

ROUND(

100.0*revenue/

SUM(revenue)

OVER(),

2

) contribution_percentage

FROM category_revenue

ORDER BY revenue DESC;



/*==============================================================================
Query 7
Business Question:
Customer Segmentation based on spending.
==============================================================================*/

WITH customer_spending AS
(

SELECT

c.customer_unique_id,

SUM(payment_value) spending

FROM customers c

JOIN orders o

ON c.customer_id=o.customer_id

JOIN payments p

ON o.order_id=p.order_id

GROUP BY c.customer_unique_id

)

SELECT

customer_unique_id,

ROUND(spending,2),

CASE

WHEN spending>=1000 THEN 'High Value'

WHEN spending>=500 THEN 'Medium Value'

ELSE 'Low Value'

END customer_segment

FROM customer_spending

ORDER BY spending DESC;



/*==============================================================================
Query 8
Business Question:
Top seller in every state.
==============================================================================*/

WITH seller_revenue AS
(

SELECT

s.seller_state,

oi.seller_id,

SUM(oi.price) revenue

FROM sellers s

JOIN order_items oi

ON s.seller_id=oi.seller_id

GROUP BY
s.seller_state,
oi.seller_id

)

SELECT *

FROM

(

SELECT

seller_state,

seller_id,

ROUND(revenue,2),

ROW_NUMBER()

OVER(

PARTITION BY seller_state

ORDER BY revenue DESC

)

ranking

FROM seller_revenue

)

WHERE ranking=1;



/*==============================================================================
Query 9
Business Question:
Identify the top 20% of customers by spending (Pareto Principle).
==============================================================================*/

WITH customer_spending AS
(
SELECT
    c.customer_unique_id,
    SUM(p.payment_value) AS spending
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN payments p
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,
    ROUND(spending,2) AS spending,
    NTILE(5) OVER(ORDER BY spending DESC) AS spending_group
FROM customer_spending
ORDER BY spending DESC;



/*==============================================================================
Query 10
Business Question:
Rank sellers by average review score.
==============================================================================*/

WITH seller_reviews AS
(
SELECT

oi.seller_id,

AVG(r.review_score) rating

FROM reviews r

JOIN orders o

ON r.order_id=o.order_id

JOIN order_items oi

ON o.order_id=oi.order_id

GROUP BY oi.seller_id

)

SELECT

seller_id,

ROUND(rating,2),

DENSE_RANK()

OVER(

ORDER BY rating DESC

)

seller_rank

FROM seller_reviews

ORDER BY seller_rank;



/*==============================================================================
End of File
==============================================================================*/