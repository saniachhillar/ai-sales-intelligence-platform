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

page_config("Operations","🚚")
load_css()

dashboard_header(
    "🚚 Operations Analysis",
    "Delivery performance and logistics insights."
)

years,states,payments=get_filter_values()

dashboard_filters(
    years,
    states,
    payments
)

delivery=run_query(delivery_time()).iloc[0,0]

late=run_query("""
SELECT COUNT(*)
FROM orders
WHERE order_delivered_customer_date>
order_estimated_delivery_date;
""").iloc[0,0]

freight=run_query("""
SELECT ROUND(AVG(freight_value),2)
FROM order_items;
""").iloc[0,0]

completed=run_query("""
SELECT COUNT(*)
FROM orders
WHERE order_status='delivered';
""").iloc[0,0]

kpi_row([
("🚚 Avg Delivery",f"{delivery:.1f} Days"),
("⏰ Late Orders",f"{late:,}"),
("💵 Avg Freight",f"R$ {freight:.2f}"),
("📦 Delivered",f"{completed:,}")
])

st.divider()

left,right=st.columns(2)

with left:

    monthly=run_query("""

    SELECT

    strftime('%Y-%m',order_purchase_timestamp) Month,

    AVG(
    julianday(order_delivered_customer_date)-
    julianday(order_purchase_timestamp)
    ) Delivery

    FROM orders

    WHERE order_delivered_customer_date IS NOT NULL

    GROUP BY Month

    ORDER BY Month;

    """)

    fig=px.line(
        monthly,
        x="Month",
        y="Delivery",
        markers=True,
        title="Monthly Delivery Time"
    )

    st.plotly_chart(fig,use_container_width=True)

with right:

    freight_df=run_query(
        freight_distribution()
    )

    fig=px.histogram(
        freight_df,
        x="freight_value",
        nbins=40,
        title="Freight Distribution"
    )

    st.plotly_chart(fig,use_container_width=True)

insight_box("""

### 📌 Operations Insights

• Delivery performance remains consistent.

• Freight costs are concentrated in lower price ranges.

• Most deliveries are completed before the estimated date.

""")

footer()