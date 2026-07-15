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
    "Sales Analysis",
    "📈"
)

load_css()

dashboard_header(
    "📈 Sales Analysis",
    "Analyze revenue, order trends and payment behaviour."
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
# KPI Cards
# =====================================================

revenue = run_query(total_revenue()).iloc[0,0]
orders = run_query(total_orders()).iloc[0,0]
avg_order = run_query(average_order_value()).iloc[0,0]

payment_types = run_query("""
SELECT COUNT(DISTINCT payment_type)
FROM payments;
""").iloc[0,0]

kpi_row([
    ("💰 Revenue", f"R$ {revenue:,.0f}"),
    ("🛒 Orders", f"{orders:,}"),
    ("🧾 Avg Order", f"R$ {avg_order:.2f}"),
    ("💳 Payment Types", f"{payment_types}")
])

st.divider()

# =====================================================
# Revenue Trend
# =====================================================

monthly = run_query(
    revenue_by_month()
)

fig = px.line(
    monthly,
    x="Month",
    y="Revenue",
    markers=True,
    title="Monthly Revenue"
)

st.plotly_chart(
    fig,
    use_container_width=True
)

# =====================================================
# Charts
# =====================================================

left, right = st.columns(2)

with left:

    status = run_query(
        revenue_by_status()
    )

    fig = px.bar(
        status,
        x="order_status",
        y="Revenue",
        color="Revenue",
        title="Revenue by Order Status"
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

with right:

    payment = run_query(
        payment_type_orders()
    )

    fig = px.pie(
        payment,
        names="payment_type",
        values="Orders",
        title="Payment Type Distribution"
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

st.divider()

# =====================================================
# Monthly Revenue Table
# =====================================================

st.subheader("Monthly Revenue")

st.dataframe(
    monthly,
    use_container_width=True,
    hide_index=True
)

# =====================================================
# Business Insights
# =====================================================

insight_box("""

### 📌 Sales Insights

• Revenue increases steadily over time.

• Credit Card is the most preferred payment method.

• Delivered orders contribute the largest share of revenue.

• Revenue shows seasonal spikes, indicating higher customer demand during specific months.

""")

footer()