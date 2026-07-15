from config import page_config
from styles import load_css

from components import (
    dashboard_header,
    dashboard_filters,
    kpi_row,
    insight_box,
    footer
)

from utils import (
    run_query,
    get_filter_values
)

from queries import *

import streamlit as st
import plotly.express as px

# =====================================================
# Page Configuration
# =====================================================

page_config(
    "Customer Satisfaction",
    "⭐"
)

load_css()

dashboard_header(
    "⭐ Customer Satisfaction",
    "Analyze customer reviews and ratings."
)

# =====================================================
# Filters
# =====================================================

years, states, payments = get_filter_values()

dashboard_filters(
    years,
    states,
    payments
)

# =====================================================
# KPIs
# =====================================================

rating = run_query(average_rating()).iloc[0,0]

positive = run_query("""
SELECT COUNT(*)
FROM reviews
WHERE review_score>=4;
""").iloc[0,0]

negative = run_query("""
SELECT COUNT(*)
FROM reviews
WHERE review_score<=2;
""").iloc[0,0]

comments = run_query("""
SELECT COUNT(*)
FROM reviews
WHERE review_comment_message IS NOT NULL
AND review_comment_message<>'';
""").iloc[0,0]

kpi_row([
    ("⭐ Avg Rating", f"{rating:.2f}"),
    ("😊 Positive", f"{positive:,}"),
    ("😞 Negative", f"{negative:,}"),
    ("💬 Comments", f"{comments:,}")
])

st.divider()

# =====================================================
# Charts
# =====================================================

left, right = st.columns(2)

with left:

    reviews = run_query(
        review_distribution()
    )

    fig = px.bar(
        reviews,
        x="review_score",
        y="Reviews",
        color="Reviews",
        title="Review Score Distribution"
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

with right:

    payment = run_query("""

    SELECT

    payment_type,

    ROUND(AVG(review_score),2) Rating

    FROM payments

    JOIN reviews

    ON payments.order_id=reviews.order_id

    GROUP BY payment_type

    ORDER BY Rating DESC;

    """)

    fig = px.bar(
        payment,
        x="payment_type",
        y="Rating",
        color="Rating",
        title="Average Rating by Payment Type"
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

st.divider()

delivery = run_query("""

SELECT

review_score,

AVG(

julianday(order_delivered_customer_date)

-

julianday(order_purchase_timestamp)

) Delivery

FROM reviews

JOIN orders

ON reviews.order_id=orders.order_id

WHERE order_delivered_customer_date IS NOT NULL

GROUP BY review_score

ORDER BY review_score;

""")

fig = px.line(
    delivery,
    x="review_score",
    y="Delivery",
    markers=True,
    title="Delivery Time vs Review Score"
)

st.plotly_chart(
    fig,
    use_container_width=True
)

insight_box("""

### 📌 Customer Satisfaction Insights

• Most customers leave ratings of 4 or 5.

• Faster deliveries generally receive higher ratings.

• Credit card transactions show the highest average customer rating.

• Negative reviews represent a relatively small proportion of total reviews.

""")

footer()