import streamlit as st


def load_css():

    st.markdown("""

    <style>

    /* ==========================================================
       Main App
    ========================================================== */

    .main{
        padding-top:1rem;
        padding-left:2rem;
        padding-right:2rem;
    }

    /* ==========================================================
       Sidebar
    ========================================================== */

    section[data-testid="stSidebar"]{
        background-color:#0E1117;
        border-right:1px solid #262730;
    }

    section[data-testid="stSidebar"] *{
        color:white;
    }

    /* Navigation Links */

    section[data-testid="stSidebar"] [data-testid="stSidebarNav"] a{
        border-radius:10px;
        padding:10px;
        color:white !important;
        transition:0.2s;
    }

    section[data-testid="stSidebar"] [data-testid="stSidebarNav"] a:hover{
        background:#262730 !important;
        color:white !important;
    }

    /* Selected Page */

    section[data-testid="stSidebar"] [aria-current="page"]{
        background:#1F77B4 !important;
        color:white !important;
        border-radius:10px;
        font-weight:600;
    }

    section[data-testid="stSidebar"] [aria-current="page"] *{
        color:white !important;
    }

    /* ==========================================================
       Headers
    ========================================================== */

    h1{
        font-size:2.5rem;
        font-weight:700;
        margin-bottom:0.5rem;
    }

    h2{
        font-size:1.8rem;
        font-weight:600;
        margin-top:1rem;
    }

    h3{
        font-weight:600;
    }

    /* ==========================================================
       KPI Cards
    ========================================================== */

    div[data-testid="metric-container"]{
        background:#161B22;
        border:1px solid #30363D;
        border-radius:12px;
        padding:18px;
        box-shadow:0 2px 6px rgba(0,0,0,.15);
    }

    div[data-testid="metric-container"]:hover{
        border-color:#1F77B4;
        transition:.25s;
    }

    /* ==========================================================
       Tables
    ========================================================== */

    .stDataFrame{
        border-radius:12px;
    }

    /* ==========================================================
       Charts
    ========================================================== */

    .js-plotly-plot{
        border-radius:12px;
    }

    /* ==========================================================
       Divider
    ========================================================== */

    hr{
        margin-top:1rem;
        margin-bottom:1rem;
    }

    /* ==========================================================
       Footer
    ========================================================== */

    footer{
        visibility:hidden;
    }

    #MainMenu{
        visibility:hidden;
    }
                /* Sidebar Header */

[data-testid="stSidebar"] h1{
    color:white;
    font-size:28px;
    font-weight:700;
}

[data-testid="stSidebar"] h3{
    color:#4EA8FF;
}

/* Sidebar Info Box */

[data-testid="stSidebar"] .stAlert{
    border-radius:12px;
}

/* Sidebar Divider */

[data-testid="stSidebar"] hr{
    margin-top:20px;
    margin-bottom:20px;
}

    </style>

    """, unsafe_allow_html=True)