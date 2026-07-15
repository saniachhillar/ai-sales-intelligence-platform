import streamlit as st

# ====================================================
# Dashboard Header
# ====================================================

def dashboard_header(title, subtitle):

    st.title(title)

    st.caption(subtitle)

    st.divider()


# ====================================================
# KPI Row
# ====================================================

def kpi_row(metrics):

    """
    metrics should be:

    [
        ("🛒 Orders","99,441"),
        ("💰 Revenue","R$16.4M"),
        ("👥 Customers","96,096"),
        ("⭐ Rating","4.1")
    ]
    """

    cols = st.columns(len(metrics))

    for col, (title, value) in zip(cols, metrics):

        with col:

            st.metric(
                title,
                value
            )


# ====================================================
# Dashboard Filters
# ====================================================

def dashboard_filters(years, states, payments):

    c1, c2, c3 = st.columns(3)

    year = c1.selectbox(
        "📅 Year",
        ["All"] + years["Year"].dropna().tolist()
    )

    state = c2.selectbox(
        "🌍 State",
        ["All"] + states["customer_state"].tolist()
    )

    payment = c3.selectbox(
        "💳 Payment Type",
        ["All"] + payments["payment_type"].tolist()
    )

    st.divider()

    return year, state, payment


# ====================================================
# Section Header
# ====================================================

def section_header(title):

    st.subheader(title)


# ====================================================
# Business Insight Box
# ====================================================

def insight_box(text):

    st.info(text)


# ====================================================
# Recommendation Box
# ====================================================

def recommendation_box(text):

    st.success(text)


# ====================================================
# Warning Box
# ====================================================

def warning_box(text):

    st.warning(text)


# ====================================================
# Download Section
# ====================================================

def download_section(df, filename):

    csv = df.to_csv(index=False)

    st.download_button(
        label="⬇ Download Data",
        data=csv,
        file_name=filename,
        mime="text/csv"
    )


# ====================================================
# Footer
# ====================================================

def footer():

    st.divider()

    st.caption(
        "Developed by Sania • Data Analytics Portfolio • Python | SQL | SQLite | Streamlit | Plotly"
    )