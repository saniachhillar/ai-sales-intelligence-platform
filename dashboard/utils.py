import sqlite3
import pandas as pd
import os
import streamlit as st

# ----------------------------------------------------
# Database Path
# ----------------------------------------------------

BASE_DIR = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..")
)

DB_PATH = os.path.join(
    BASE_DIR,
    "data",
    "processed",
    "olist.db"
)

# ----------------------------------------------------
# Database Connection
# ----------------------------------------------------

@st.cache_resource
def get_connection():

    return sqlite3.connect(
        DB_PATH,
        check_same_thread=False
    )

# ----------------------------------------------------
# Run Query
# ----------------------------------------------------

@st.cache_data
def run_query(query):

    conn = get_connection()

    return pd.read_sql(query, conn)

# ----------------------------------------------------
# Filter Values
# ----------------------------------------------------

@st.cache_data
def get_filter_values():

    years = run_query("""
    SELECT DISTINCT
    strftime('%Y',order_purchase_timestamp) Year
    FROM orders
    ORDER BY Year
    """)

    states = run_query("""
    SELECT DISTINCT
    customer_state
    FROM customers
    ORDER BY customer_state
    """)

    payments = run_query("""
    SELECT DISTINCT
    payment_type
    FROM payments
    ORDER BY payment_type
    """)

    return years, states, payments

# ----------------------------------------------------
# Dynamic WHERE Clause
# ----------------------------------------------------

def build_where_clause(
    year="All",
    state="All",
    payment="All"
):

    conditions=[]

    if year!="All":

        conditions.append(
            f"strftime('%Y',orders.order_purchase_timestamp)='{year}'"
        )

    if state!="All":

        conditions.append(
            f"customers.customer_state='{state}'"
        )

    if payment!="All":

        conditions.append(
            f"payments.payment_type='{payment}'"
        )

    if len(conditions)==0:

        return ""

    return "WHERE " + " AND ".join(conditions)