import sqlite3
import pandas as pd
from pathlib import Path

# Project root
BASE_DIR = Path(__file__).resolve().parent.parent

RAW = BASE_DIR / "data" / "raw"
PROCESSED = BASE_DIR / "data" / "processed"

# Create processed folder if it doesn't exist
PROCESSED.mkdir(parents=True, exist_ok=True)

conn = sqlite3.connect(PROCESSED / "olist.db")

customers = pd.read_csv(RAW / "olist_customers_dataset.csv")
orders = pd.read_csv(RAW / "olist_orders_dataset.csv")
order_items = pd.read_csv(RAW / "olist_order_items_dataset.csv")
payments = pd.read_csv(RAW / "olist_order_payments_dataset.csv")
products = pd.read_csv(RAW / "olist_products_dataset.csv")
reviews = pd.read_csv(RAW / "olist_order_reviews_dataset.csv")
sellers = pd.read_csv(RAW / "olist_sellers_dataset.csv")
geolocation = pd.read_csv(RAW / "olist_geolocation_dataset.csv")
category_translation = pd.read_csv(RAW / "product_category_name_translation.csv")

customers.to_sql("customers", conn, if_exists="replace", index=False)
orders.to_sql("orders", conn, if_exists="replace", index=False)
order_items.to_sql("order_items", conn, if_exists="replace", index=False)
payments.to_sql("payments", conn, if_exists="replace", index=False)
products.to_sql("products", conn, if_exists="replace", index=False)
reviews.to_sql("reviews", conn, if_exists="replace", index=False)
sellers.to_sql("sellers", conn, if_exists="replace", index=False)
geolocation.to_sql("geolocation", conn, if_exists="replace", index=False)
category_translation.to_sql("category_translation", conn, if_exists="replace", index=False)

conn.close()

print("Database created successfully!")