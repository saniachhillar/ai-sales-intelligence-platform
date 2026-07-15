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
    "Product Analysis",
    "📦"
)

load_css()

dashboard_header(
    "📦 Product Analysis",
    "Analyze products, categories and pricing."
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

products = run_query("""
SELECT COUNT(DISTINCT product_id)
FROM products;
""").iloc[0,0]

categories = run_query("""
SELECT COUNT(DISTINCT product_category_name)
FROM products;
""").iloc[0,0]

avg_price = run_query("""
SELECT ROUND(AVG(price),2)
FROM order_items;
""").iloc[0,0]

max_price = run_query("""
SELECT ROUND(MAX(price),2)
FROM order_items;
""").iloc[0,0]

kpi_row([
    ("📦 Products", f"{products:,}"),
    ("🏷 Categories", f"{categories:,}"),
    ("💰 Avg Price", f"R$ {avg_price:.2f}"),
    ("💎 Highest Price", f"R$ {max_price:.2f}")
])

st.divider()

# =====================================================
# Top Categories
# =====================================================

category_orders = run_query(
    top_categories()
)

fig = px.bar(
    category_orders,
    x="Orders",
    y="product_category_name",
    orientation="h",
    color="Orders",
    title="Top Product Categories"
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

    revenue = run_query(
        category_revenue()
    )

    fig = px.bar(
        revenue,
        x="Revenue",
        y="product_category_name",
        orientation="h",
        color="Revenue",
        title="Highest Revenue Categories"
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

with right:

    prices = run_query(
        product_prices()
    )

    fig = px.histogram(
        prices,
        x="price",
        nbins=50,
        title="Product Price Distribution"
    )

    st.plotly_chart(
        fig,
        use_container_width=True
    )

st.divider()

st.subheader("Top Categories")

st.dataframe(
    category_orders,
    use_container_width=True,
    hide_index=True
)

insight_box("""

### 📌 Product Insights

• Bed, Bath & Table is one of the highest-selling categories.

• A small number of categories generate a large share of total revenue.

• Most products are priced below R$200.

• Premium products exist but contribute a smaller share of total orders.

""")

footer()