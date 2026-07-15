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
    "Customer Analysis",
    "👥"
)

load_css()

dashboard_header(
    "👥 Customer Analysis",
    "Analyze customer growth, locations and purchasing trends."
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

customers = run_query(total_customers()).iloc[0,0]

states_count = run_query("""
SELECT COUNT(DISTINCT customer_state)
FROM customers;
""").iloc[0,0]

cities = run_query("""
SELECT COUNT(DISTINCT customer_city)
FROM customers;
""").iloc[0,0]

avg_orders = run_query("""
SELECT ROUND(
COUNT(*)*1.0/
COUNT(DISTINCT customer_id),2)
FROM orders;
""").iloc[0,0]

kpi_row([
    ("👥 Customers", f"{customers:,}"),
    ("🌍 States", f"{states_count}"),
    ("🏙 Cities", f"{cities:,}"),
    ("🛒 Avg Orders/Customer", f"{avg_orders}")
])

st.divider()

# =====================================================
# Customer Growth
# =====================================================

growth = run_query(
    customer_growth()
)

fig = px.line(
    growth,
    x="Month",
    y="Customers",
    markers=True,
    title="Customer Growth Over Time"
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

    state = run_query(
        customers_by_state()
    )

    fig = px.bar(
        state,
        x="customer_state",
        y="Customers",
        color="Customers",
        title="Customers by State"
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

with right:

    city = run_query(
        top_customer_cities()
    )

    fig = px.bar(
        city,
        x="Customers",
        y="customer_city",
        orientation="h",
        color="Customers",
        title="Top Customer Cities"
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

st.divider()

st.subheader("Customer Dataset")

st.dataframe(
    city,
    use_container_width=True,
    hide_index=True
)

insight_box("""

### 📌 Customer Insights

• São Paulo has the highest customer concentration.

• Customer acquisition increased steadily throughout the dataset.

• Customers are widely distributed across Brazil.

• Large metropolitan cities contribute the majority of marketplace demand.

""")

footer()