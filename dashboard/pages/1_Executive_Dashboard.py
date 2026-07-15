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
    "Executive Dashboard",
    "📊"
)

load_css()

dashboard_header(
    "📊 Executive Dashboard",
    "High-level overview of marketplace performance."
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

orders = run_query(total_orders()).iloc[0,0]

customers = run_query(total_customers()).iloc[0,0]

revenue = run_query(total_revenue()).iloc[0,0]

avg_order = run_query(average_order_value()).iloc[0,0]

kpi_row([
    ("🛒 Orders", f"{orders:,}"),
    ("👥 Customers", f"{customers:,}"),
    ("💰 Revenue", f"R$ {revenue:,.0f}"),
    ("🧾 Avg Order", f"R$ {avg_order:.2f}")
])

st.divider()

# =====================================================
# Revenue Trend
# =====================================================

monthly = run_query(
    monthly_revenue()
)

fig = px.line(
    monthly,
    x="Month",
    y="Revenue",
    markers=True,
    title="Monthly Revenue Trend"
)

st.plotly_chart(
    fig,
    use_container_width=True
)

# =====================================================
# Charts
# =====================================================

left,right = st.columns(2)

with left:

    status = run_query(
        order_status_distribution()
    )

    fig = px.pie(
        status,
        names="order_status",
        values="Orders",
        title="Order Status Distribution"
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

with right:

    payment = run_query(
        payment_distribution()
    )

    fig = px.bar(
        payment,
        x="payment_type",
        y="Orders",
        color="Orders",
        title="Payment Method Distribution"
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

# =====================================================
# Business Insights
# =====================================================

insight_box("""

### 📌 Executive Insights

• Revenue shows a clear upward trend over time.

• Credit Card is the dominant payment method.

• The majority of orders are successfully delivered.

• The marketplace serves more than **96,000 customers**.

• Revenue is concentrated during seasonal shopping periods.

""")

footer()