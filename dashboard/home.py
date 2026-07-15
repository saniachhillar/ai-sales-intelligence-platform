from config import page_config
from styles import load_css

import streamlit as st

# --------------------------------------------------
# Page Config
# --------------------------------------------------

page_config(
    "Olist E-Commerce Analytics",
    "📊"
)

load_css()

# --------------------------------------------------
# Sidebar
# --------------------------------------------------

with st.sidebar:

    st.markdown("# 📊 Olist Analytics")

    st.caption("Business Intelligence Dashboard")

    st.divider()

    st.divider()

    st.caption("Built using Python • SQL • Streamlit")

# --------------------------------------------------
# Home Page
# --------------------------------------------------

st.title("📊 Olist E-Commerce Analytics Dashboard")

st.markdown("---")

st.header("Welcome")

st.write("""
This interactive Business Intelligence dashboard analyzes the Brazilian Olist E-Commerce dataset using **Python, SQL, Pandas, Plotly and Streamlit**.

The objective of this project is to generate business insights across sales, customers, products, sellers, logistics and customer satisfaction.
""")

st.markdown("---")

st.header("📈 Dashboard Modules")

st.markdown("""
- Executive Dashboard
- Sales Analysis
- Customer Analysis
- Product Analysis
- Seller Analysis
- Operations Analysis
- Customer Satisfaction
""")

st.markdown("---")

st.header("🛠 Technologies Used")

st.markdown("""
- Python
- SQL
- SQLite
- Pandas
- NumPy
- Plotly
- Streamlit
""")

st.markdown("---")

st.header("📊 Dataset")

st.write("""
The dashboard uses the **Olist Brazilian E-Commerce Dataset**, containing:

- 99,000+ Orders
- 96,000+ Customers
- 112,000+ Order Items
- 32,000+ Sellers
- 3,000+ Product Categories
""")

st.markdown("---")

st.header("🎯 Project Objectives")

st.markdown("""
✅ Analyze sales performance

✅ Understand customer purchasing behavior

✅ Evaluate seller performance

✅ Identify top-performing products

✅ Measure delivery efficiency

✅ Analyze customer reviews and ratings

✅ Build an interactive business intelligence dashboard
""")