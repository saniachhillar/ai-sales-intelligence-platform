import streamlit as st
import pandas as pd
import plotly.express as px
import numpy as np

from prophet import Prophet
from sklearn.metrics import mean_absolute_error, mean_squared_error

from utils import run_query

# ==========================================================
# Page Configuration
# ==========================================================

st.set_page_config(
    page_title="Sales Forecasting",
    layout="wide"
)

st.title("📈 AI Sales Forecasting")
st.caption("Forecast future sales using Facebook Prophet.")

st.divider()

# ==========================================================
# Product Category Filter
# ==========================================================

categories = run_query("""
SELECT DISTINCT
    product_category_name
FROM products
WHERE product_category_name IS NOT NULL
ORDER BY product_category_name
""")

category = st.selectbox(
    "📦 Product Category",
    ["All Categories"] + categories["product_category_name"].tolist()
)

st.divider()

# ==========================================================
# Load Data
# ==========================================================

if category == "All Categories":

    query = """
    SELECT
        DATE(order_purchase_timestamp) AS ds,
        SUM(payment_value) AS y
    FROM orders
    JOIN payments
        ON orders.order_id = payments.order_id
    GROUP BY DATE(order_purchase_timestamp)
    ORDER BY ds
    """

else:

    query = f"""
    SELECT
        DATE(orders.order_purchase_timestamp) AS ds,
        SUM(payments.payment_value) AS y
    FROM orders
    JOIN payments
        ON orders.order_id = payments.order_id
    JOIN order_items
        ON orders.order_id = order_items.order_id
    JOIN products
        ON order_items.product_id = products.product_id
    WHERE products.product_category_name = '{category}'
    GROUP BY DATE(orders.order_purchase_timestamp)
    ORDER BY ds
    """

df = run_query(query)

df["ds"] = pd.to_datetime(df["ds"])

# ==========================================================
# Forecast Horizon
# ==========================================================

periods = st.slider(
    "Forecast Days",
    30,
    365,
    90
)

# ==========================================================
# Train Prophet Model
# ==========================================================

model = Prophet()

model.fit(df)

future = model.make_future_dataframe(periods=periods)

forecast = model.predict(future)

# ==========================================================
# Model Evaluation
# ==========================================================

history = forecast.iloc[:len(df)]

mae = mean_absolute_error(
    df["y"],
    history["yhat"]
)

rmse = np.sqrt(
    mean_squared_error(
        df["y"],
        history["yhat"]
    )
)

# ==========================================================
# Forecast Summary
# ==========================================================

future_sales = forecast.tail(periods)

avg_sales = future_sales["yhat"].mean()
max_sales = future_sales["yhat"].max()
min_sales = future_sales["yhat"].min()

c1, c2, c3, c4, c5 = st.columns(5)

c1.metric(
    "Average Forecast",
    f"R$ {avg_sales:,.0f}"
)

c2.metric(
    "Highest Forecast",
    f"R$ {max_sales:,.0f}"
)

c3.metric(
    "Lowest Forecast",
    f"R$ {min_sales:,.0f}"
)

c4.metric(
    "MAE",
    f"{mae:,.0f}"
)

c5.metric(
    "RMSE",
    f"{rmse:,.0f}"
)

st.divider()

# ==========================================================
# Forecast Plot
# ==========================================================

fig = px.line(
    forecast,
    x="ds",
    y="yhat",
    title="Predicted Sales with Confidence Interval"
)

fig.add_scatter(
    x=forecast["ds"],
    y=forecast["yhat_upper"],
    mode="lines",
    name="Upper Confidence",
    line=dict(dash="dot")
)

fig.add_scatter(
    x=forecast["ds"],
    y=forecast["yhat_lower"],
    mode="lines",
    name="Lower Confidence",
    line=dict(dash="dot"),
    fill="tonexty"
)

fig.add_scatter(
    x=df["ds"],
    y=df["y"],
    mode="lines",
    name="Actual Sales"
)

st.plotly_chart(
    fig,
    use_container_width=True
)

# ==========================================================
# AI Business Insights
# ==========================================================

st.subheader("🤖 AI Business Insights")

trend = future_sales["yhat"].iloc[-1] - future_sales["yhat"].iloc[0]

if trend > 0:

    st.success(
        f"""
Sales are expected to increase by approximately **R$ {trend:,.0f}**
during the selected forecast period.

### Recommendation
- Increase inventory
- Prepare logistics capacity
- Plan promotional campaigns
"""
    )

else:

    st.warning(
        f"""
Sales are expected to decrease by approximately **R$ {abs(trend):,.0f}**
during the selected forecast period.

### Recommendation
- Review marketing strategy
- Focus on customer retention
- Optimize inventory planning
"""
    )

# ==========================================================
# Forecast Table
# ==========================================================

st.subheader("Forecast")

st.dataframe(
    forecast[
        ["ds", "yhat", "yhat_lower", "yhat_upper"]
    ].tail(periods),
    use_container_width=True
)

# ==========================================================
# Download Forecast
# ==========================================================

csv = forecast.tail(periods).to_csv(index=False)

st.download_button(
    label="⬇ Download Forecast CSV",
    data=csv,
    file_name="sales_forecast.csv",
    mime="text/csv"
)