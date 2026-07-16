import pandas as pd
from sqlalchemy import create_engine, text

engine = create_engine("mysql+pymysql://root:nani@localhost:3307/RetailDW")

df = pd.read_csv("Transformed_CSV/customer_clean.csv")

print("Connected Successfully!")

files = {
    "customers":"Transformed_CSV/customer_clean.csv",
    "location":"Transformed_CSV/location_clean.csv",
    "orders":"Transformed_CSV/orders_clean.csv",
    "products":"Transformed_CSV/products_clean.csv",
    "sellers":"Transformed_CSV/sellers_clean.csv",
    "order_items":"Transformed_CSV/order_items_clean.csv",
    "payments":"Transformed_CSV/payments_clean.csv",
    "product_category":"Transformed_CSV/product_category_clean.csv",
    "reviews":"Transformed_CSV/reviews_clean.csv"
}

with engine.connect() as conn:
    for table, file in files.items():
        df = pd.read_csv(file)
        csv_count = len(df)

        sql_count = conn.execute(
            text(f"SELECT COUNT(*) FROM {table}")
        ).scalar()

        status = "✅ PASS" if csv_count == sql_count else "❌ FAIL"

        print(f"{table:10} | CSV: {csv_count:8} | SQL: {sql_count:8} | {status}")