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
    "Seller Analysis",
    "🏪"
)

load_css()

dashboard_header(
    "🏪 Seller Analysis",
    "Analyze seller performance and marketplace contribution."
)

# =====================================================
# Filters
# =====================================================

years, states, payments = get_filter_values()

year, state, payment = dashboard_filters(
    years,
    states,
    payments
)

# =====================================================
# KPIs
# =====================================================

total_sellers = run_query("""
SELECT COUNT(*) FROM sellers;
""").iloc[0,0]

avg_revenue = run_query("""
SELECT ROUND(AVG(revenue),2)
FROM(
SELECT seller_id,
SUM(price) revenue
FROM order_items
GROUP BY seller_id
);
""").iloc[0,0]

top_revenue = run_query("""
SELECT ROUND(MAX(revenue),2)
FROM(
SELECT seller_id,
SUM(price) revenue
FROM order_items
GROUP BY seller_id
);
""").iloc[0,0]

states = run_query("""
SELECT COUNT(DISTINCT seller_state)
FROM sellers;
""").iloc[0,0]

kpi_row([
    ("🏪 Sellers",f"{total_sellers:,}"),
    ("💰 Avg Revenue",f"R$ {avg_revenue:,.0f}"),
    ("🏆 Top Seller",f"R$ {top_revenue:,.0f}"),
    ("🌍 States",f"{states}")
])

st.divider()

# =====================================================
# Charts
# =====================================================

left,right = st.columns(2)

with left:

    revenue = run_query(seller_revenue())

    fig = px.bar(
        revenue,
        x="Revenue",
        y="seller_id",
        orientation="h",
        title="Top Sellers by Revenue",
        color="Revenue"
    )

    st.plotly_chart(fig,use_container_width=True)

with right:

    orders = run_query(seller_orders())

    fig = px.bar(
        orders,
        x="Orders",
        y="seller_id",
        orientation="h",
        title="Top Sellers by Orders",
        color="Orders"
    )

    st.plotly_chart(fig,use_container_width=True)

st.divider()

seller_state = run_query(
    sellers_by_state()
)

fig = px.bar(
    seller_state,
    x="seller_state",
    y="Sellers",
    color="Sellers",
    title="Seller Distribution by State"
)

st.plotly_chart(fig,use_container_width=True)

insight_box("""

### 📌 Seller Insights

• A small number of sellers generate a significant portion of marketplace revenue.

• Sellers are concentrated in the southeast region of Brazil.

• Top-performing sellers process substantially more orders than the marketplace average.

""")

footer()