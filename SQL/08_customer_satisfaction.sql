/*==============================================================================
 OLIST E-COMMERCE ANALYTICS PROJECT
 File: 08_customer_satisfaction.sql

 Purpose:
 Analyze customer satisfaction using review scores and identify
 factors influencing customer experience.

 Author: Sania
==============================================================================*/


/*==============================================================================
Query 1
Business Question:
What is the distribution of review scores?
==============================================================================*/

SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score;



/*==============================================================================
Query 2
Business Question:
What is the average customer review score?
==============================================================================*/

SELECT
    ROUND(AVG(review_score),2) AS average_review_score
FROM reviews;



/*==============================================================================
Query 3
Business Question:
Which product categories receive the highest average ratings?
==============================================================================*/

SELECT

    pct.product_category_name_english AS category,

    ROUND(AVG(r.review_score),2) AS average_rating

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

ORDER BY average_rating DESC;



/*==============================================================================
Query 4
Business Question:
Which product categories receive the lowest average ratings?
==============================================================================*/

SELECT

    pct.product_category_name_english AS category,

    ROUND(AVG(r.review_score),2) AS average_rating

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

ORDER BY average_rating ASC

LIMIT 20;



/*==============================================================================
Query 5
Business Question:
Which sellers receive the highest average customer ratings?
==============================================================================*/

SELECT

    oi.seller_id,

    ROUND(AVG(r.review_score),2) AS average_rating

FROM reviews r

JOIN orders o
ON r.order_id = o.order_id

JOIN order_items oi
ON o.order_id = oi.order_id

GROUP BY oi.seller_id

ORDER BY average_rating DESC

LIMIT 20;



/*==============================================================================
Query 6
Business Question:
Which sellers receive the lowest average customer ratings?
==============================================================================*/

SELECT

    oi.seller_id,

    ROUND(AVG(r.review_score),2) AS average_rating

FROM reviews r

JOIN orders o
ON r.order_id = o.order_id

JOIN order_items oi
ON o.order_id = oi.order_id

GROUP BY oi.seller_id

ORDER BY average_rating ASC

LIMIT 20;



/*==============================================================================
Query 7
Business Question:
How does delivery time affect customer ratings?
==============================================================================*/

SELECT

    r.review_score,

    ROUND(

        AVG(

            julianday(o.order_delivered_customer_date)

            -

            julianday(o.order_purchase_timestamp)

        ),

        2

    ) AS average_delivery_days

FROM reviews r

JOIN orders o

ON r.order_id = o.order_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY r.review_score

ORDER BY r.review_score;



/*==============================================================================
Query 8
Business Question:
How does delivery delay affect customer ratings?
==============================================================================*/

SELECT

    r.review_score,

    ROUND(

        AVG(

            julianday(o.order_delivered_customer_date)

            -

            julianday(o.order_estimated_delivery_date)

        ),

        2

    ) AS average_delay

FROM reviews r

JOIN orders o

ON r.order_id = o.order_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY r.review_score

ORDER BY r.review_score;



/*==============================================================================
Query 9
Business Question:
Do higher-priced orders receive better ratings?
==============================================================================*/

SELECT

    r.review_score,

    ROUND(AVG(p.payment_value),2) AS average_order_value

FROM reviews r

JOIN payments p

ON r.order_id = p.order_id

GROUP BY r.review_score

ORDER BY r.review_score;



/*==============================================================================
Query 10
Business Question:
Which payment methods receive the highest customer ratings?
==============================================================================*/

SELECT

    p.payment_type,

    ROUND(AVG(r.review_score),2) AS average_rating

FROM payments p

JOIN reviews r

ON p.order_id = r.order_id

GROUP BY p.payment_type

ORDER BY average_rating DESC;



/*==============================================================================
Query 11
Business Question:
Do customers who pay in installments give different ratings?
==============================================================================*/

SELECT

    payment_installments,

    ROUND(AVG(r.review_score),2) AS average_rating

FROM payments p

JOIN reviews r

ON p.order_id = r.order_id

GROUP BY payment_installments

ORDER BY payment_installments;



/*==============================================================================
Query 12
Business Question:
What percentage of reviews are positive (4★ and 5★)?
==============================================================================*/

SELECT

ROUND(

100.0 *

SUM(

CASE

WHEN review_score >=4

THEN 1

ELSE 0

END

)

/

COUNT(*)

,2

) AS positive_review_percentage

FROM reviews;



/*==============================================================================
Query 13
Business Question:
What percentage of reviews are negative (1★ and 2★)?
==============================================================================*/

SELECT

ROUND(

100.0 *

SUM(

CASE

WHEN review_score <=2

THEN 1

ELSE 0

END

)

/

COUNT(*)

,2

) AS negative_review_percentage

FROM reviews;



/*==============================================================================
Query 14
Business Question:
How many reviews contain written comments?
==============================================================================*/

SELECT

COUNT(*) AS reviews_with_comments

FROM reviews

WHERE review_comment_message IS NOT NULL;



/*==============================================================================
Query 15
Business Question:
Which review score occurs most frequently?
==============================================================================*/

SELECT

review_score,

COUNT(*) AS total_reviews

FROM reviews

GROUP BY review_score

ORDER BY total_reviews DESC

LIMIT 1;



/*==============================================================================
End of File
==============================================================================*/