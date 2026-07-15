/*==============================================================================
 OLIST E-COMMERCE ANALYTICS PROJECT
 File: 07_operations_analysis.sql

 Purpose:
 Analyze delivery performance, logistics efficiency, freight costs,
 shipping timelines, and operational KPIs.

 Author: Sania
==============================================================================*/


/*==============================================================================
Query 1
Business Question:
What is the average delivery time for completed orders?
==============================================================================*/

SELECT
    ROUND(
        AVG(
            julianday(order_delivered_customer_date) -
            julianday(order_purchase_timestamp)
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;



/*==============================================================================
Query 2
Business Question:
What is the average shipping time from purchase to carrier pickup?
==============================================================================*/

SELECT
    ROUND(
        AVG(
            julianday(order_delivered_carrier_date) -
            julianday(order_purchase_timestamp)
        ),
        2
    ) AS average_shipping_days
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL;



/*==============================================================================
Query 3
Business Question:
How many orders were delivered late?
==============================================================================*/

SELECT
    COUNT(*) AS late_orders
FROM orders
WHERE order_delivered_customer_date >
      order_estimated_delivery_date;



/*==============================================================================
Query 4
Business Question:
What percentage of delivered orders were late?
==============================================================================*/

SELECT

ROUND(

100.0 *

SUM(

CASE

WHEN order_delivered_customer_date >
order_estimated_delivery_date

THEN 1

ELSE 0

END

)

/

COUNT(*)

,2

) AS late_delivery_percentage

FROM orders

WHERE order_delivered_customer_date IS NOT NULL;



/*==============================================================================
Query 5
Business Question:
What is the average delivery time by customer state?
==============================================================================*/

SELECT

c.customer_state,

ROUND(

AVG(

julianday(o.order_delivered_customer_date)

-

julianday(o.order_purchase_timestamp)

),

2

) AS average_delivery_days

FROM customers c

JOIN orders o

ON c.customer_id=o.customer_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY c.customer_state

ORDER BY average_delivery_days DESC;



/*==============================================================================
Query 6
Business Question:
Which states experience the highest percentage of late deliveries?
==============================================================================*/

SELECT

c.customer_state,

ROUND(

100.0 *

SUM(

CASE

WHEN o.order_delivered_customer_date >
o.order_estimated_delivery_date

THEN 1

ELSE 0

END

)

/

COUNT(*)

,2

) AS late_delivery_percentage

FROM customers c

JOIN orders o

ON c.customer_id=o.customer_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY c.customer_state

ORDER BY late_delivery_percentage DESC;



/*==============================================================================
Query 7
Business Question:
What is the average freight cost by seller state?
==============================================================================*/

SELECT

s.seller_state,

ROUND(

AVG(oi.freight_value),

2

) AS average_freight

FROM sellers s

JOIN order_items oi

ON s.seller_id=oi.seller_id

GROUP BY s.seller_state

ORDER BY average_freight DESC;



/*==============================================================================
Query 8
Business Question:
Which sellers have the shortest average delivery time?
==============================================================================*/

SELECT

oi.seller_id,

ROUND(

AVG(

julianday(o.order_delivered_customer_date)

-

julianday(o.order_purchase_timestamp)

),

2

) AS average_delivery_days

FROM order_items oi

JOIN orders o

ON oi.order_id=o.order_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY oi.seller_id

ORDER BY average_delivery_days ASC

LIMIT 20;



/*==============================================================================
Query 9
Business Question:
Which sellers have the longest average delivery time?
==============================================================================*/

SELECT

oi.seller_id,

ROUND(

AVG(

julianday(o.order_delivered_customer_date)

-

julianday(o.order_purchase_timestamp)

),

2

) AS average_delivery_days

FROM order_items oi

JOIN orders o

ON oi.order_id=o.order_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY oi.seller_id

ORDER BY average_delivery_days DESC

LIMIT 20;



/*==============================================================================
Query 10
Business Question:
Which product categories incur the highest average freight cost?
==============================================================================*/

SELECT

pct.product_category_name_english AS category,

ROUND(

AVG(oi.freight_value),

2

) AS average_freight

FROM order_items oi

JOIN products p

ON oi.product_id=p.product_id

JOIN category_translation pct

ON p.product_category_name=pct.product_category_name

GROUP BY category

ORDER BY average_freight DESC;



/*==============================================================================
Query 11
Business Question:
How many days early or late are deliveries on average?
==============================================================================*/

SELECT

ROUND(

AVG(

julianday(order_delivered_customer_date)

-

julianday(order_estimated_delivery_date)

),

2

) AS average_delivery_delay

FROM orders

WHERE order_delivered_customer_date IS NOT NULL;



/*==============================================================================
Query 12
Business Question:
Which months experience the longest delivery times?
==============================================================================*/

SELECT

strftime('%Y-%m',order_purchase_timestamp) AS purchase_month,

ROUND(

AVG(

julianday(order_delivered_customer_date)

-

julianday(order_purchase_timestamp)

),

2

) AS average_delivery_days

FROM orders

WHERE order_delivered_customer_date IS NOT NULL

GROUP BY purchase_month

ORDER BY average_delivery_days DESC;



/*==============================================================================
Query 13
Business Question:
What is the average freight cost for each payment type?
==============================================================================*/

SELECT

p.payment_type,

ROUND(

AVG(oi.freight_value),

2

) AS average_freight

FROM payments p

JOIN order_items oi

ON p.order_id=oi.order_id

GROUP BY p.payment_type

ORDER BY average_freight DESC;



/*==============================================================================
Query 14
Business Question:
Which orders had the longest delivery time?
==============================================================================*/

SELECT

order_id,

ROUND(

julianday(order_delivered_customer_date)

-

julianday(order_purchase_timestamp),

2

) AS delivery_days

FROM orders

WHERE order_delivered_customer_date IS NOT NULL

ORDER BY delivery_days DESC

LIMIT 20;



/*==============================================================================
Query 15
Business Question:
What is the average delivery time for each order status?
==============================================================================*/

SELECT

order_status,

ROUND(

AVG(

julianday(order_delivered_customer_date)

-

julianday(order_purchase_timestamp)

),

2

) AS average_delivery_days

FROM orders

WHERE order_delivered_customer_date IS NOT NULL

GROUP BY order_status

ORDER BY average_delivery_days;



/*==============================================================================
End of File
==============================================================================*/