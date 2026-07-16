import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError

# =====================================
# MySQL Connection
# =====================================

engine = create_engine(
    "mysql+pymysql://root:nani@localhost:3307/RetailDW"
)

print("Connected Successfully!")

# =====================================
# Read CSV Files
# =====================================

customer = pd.read_csv("Transformed_CSV/customer_clean.csv")
location = pd.read_csv("Transformed_CSV/location_clean.csv")
orders = pd.read_csv("Transformed_CSV/orders_clean.csv")
products = pd.read_csv("Transformed_CSV/products_clean.csv")
sellers = pd.read_csv("Transformed_CSV/sellers_clean.csv")
order_items = pd.read_csv("Transformed_CSV/order_items_clean.csv")
payments = pd.read_csv("Transformed_CSV/payments_clean.csv")
product_category = pd.read_csv("Transformed_CSV/product_category_clean.csv")
reviews = pd.read_csv("Transformed_CSV/reviews_clean.csv")


# =====================================
# Incremental Load Function
# =====================================

def load_incremental(df, table_name, pk_columns):

    try:

        # Remove duplicate rows from CSV
        df = df.drop_duplicates(subset=pk_columns)

        # Read existing business keys
        query = f"""
        SELECT {', '.join(pk_columns)}
        FROM {table_name}
        """

        existing = pd.read_sql(text(query), engine)

        # Make datatypes identical
        for col in pk_columns:
            df[col] = df[col].astype(str)
            existing[col] = existing[col].astype(str)

        # First load
        if existing.empty:

            df.to_sql(
                table_name,
                con=engine,
                if_exists="append",
                index=False
            )

            print(f"{table_name}: Loaded {len(df)} rows.")
            return

        # Find new rows
        new_rows = df.merge(
            existing,
            on=pk_columns,
            how="left",
            indicator=True
        )

        new_rows = new_rows[
            new_rows["_merge"] == "left_only"
        ].drop(columns="_merge")

        if new_rows.empty:
            print(f"{table_name}: No new records found.")
            return

        new_rows.to_sql(
            table_name,
            con=engine,
            if_exists="append",
            index=False
        )

        print(f"{table_name}: {len(new_rows)} new rows inserted.")

    except SQLAlchemyError as e:
        print(f"\nDatabase Error while loading {table_name}")
        print(e)

    except Exception as e:
        print(f"\nUnexpected Error while loading {table_name}")
        print(e)


# =====================================
# Full Refresh Function (Location)
# =====================================

def load_full_refresh(df, table_name):

    try:

        with engine.begin() as conn:
            conn.execute(text(f"TRUNCATE TABLE {table_name}"))

        df.to_sql(
            table_name,
            con=engine,
            if_exists="append",
            index=False
        )

        print(f"{table_name}: Reloaded successfully ({len(df)} rows).")

    except SQLAlchemyError as e:
        print(f"\nDatabase Error while loading {table_name}")
        print(e)

    except Exception as e:
        print(f"\nUnexpected Error while loading {table_name}")
        print(e)


# =====================================
# Load Tables
# =====================================

load_incremental(
    customer,
    "customers",
    ["customer_id"]
)

# Full Refresh
load_full_refresh(
    location,
    "location"
)

load_incremental(
    orders,
    "orders",
    ["order_id"]
)

load_incremental(
    sellers,
    "sellers",
    ["seller_id"]
)

load_incremental(
    products,
    "products",
    ["product_id"]
)

load_incremental(
    order_items,
    "order_items",
    ["order_id", "order_item_id"]
)

load_incremental(
    payments,
    "payments",
    ["order_id", "payment_sequential"]
)

load_incremental(
    product_category,
    "product_category",
    ["product_category_name"]
)

load_incremental(
    reviews,
    "reviews",
    ["review_id", "order_id"]
)

print("\nETL Loading Completed Successfully!")