# Olist E-Commerce Data Warehouse & Business Intelligence Analytics

## 📌 Project Overview

This project builds an end-to-end **E-Commerce Data Analytics and Business Intelligence pipeline** using the Brazilian Olist e-commerce dataset.

The project covers the complete journey from raw CSV data to business-ready dashboards:

**Raw CSV Data → Python ETL → MySQL Data Warehouse → SQL Analytics → Power BI → Interactive Dashboard**

The objective is to transform raw transactional data into a structured analytical data warehouse and provide actionable business insights into sales, customers, products, sellers, reviews, regions, and delivery performance.

---

## 🏗️ Architecture

```text
                    ┌─────────────────────┐
                    │   Olist CSV Files   │
                    │ Customers / Orders  │
                    │ Products / Sellers  │
                    │ Payments / Reviews  │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │      Python ETL     │
                    │                     │
                    │ Extract             │
                    │ Clean & Transform   │
                    │ Validate            │
                    │ Load                │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │        MySQL        │
                    │    RetailDW        │
                    │                     │
                    │ Dimension Tables    │
                    │ Fact Tables         │
                    └──────────┬──────────┘
                               │
                 ┌─────────────┴─────────────┐
                 ▼                           ▼
        ┌─────────────────┐         ┌─────────────────┐
        │  SQL Analytics  │         │     Power BI    │
        │                 │         │                 │
        │ Revenue         │         │ KPI Cards       │
        │ Orders          │         │ Sales Trends    │
        │ Customers       │         │ Customer Seg.   │
        │ Sellers         │         │ Regional Map    │
        │ Products        │         │ Reviews         │
        └─────────────────┘         │ Delivery Time   │
                                    └─────────────────┘
```

---

## 🛠️ Technology Stack

- **Python** – ETL, data cleaning and transformation
- **Pandas** – Data manipulation and preprocessing
- **NumPy** – Numerical operations
- **SQLAlchemy** – Python-to-MySQL database connectivity
- **MySQL** – Relational data warehouse and SQL analytics
- **SQL** – Business analytics and data validation
- **Power BI** – Interactive dashboard and visualization
- **Git/GitHub** – Version control and project management

---

## 📂 Dataset

The project uses the **Brazilian Olist E-Commerce dataset**, containing information related to:

- Customers
- Customer locations
- Orders
- Order items
- Payments
- Products
- Product categories
- Sellers
- Reviews

The data contains order-level, customer-level, product-level, seller-level, payment, review, and geographic information.

---

# 🔄 ETL Pipeline

## 1. Extract

Raw CSV files were loaded into Python using Pandas.

Example:

```python
import pandas as pd

orders = pd.read_csv("orders.csv")
customers = pd.read_csv("customers.csv")
order_items = pd.read_csv("order_items.csv")
products = pd.read_csv("products.csv")
sellers = pd.read_csv("sellers.csv")
reviews = pd.read_csv("reviews.csv")
payments = pd.read_csv("payments.csv")
```

The extraction layer keeps the raw source data separate from the transformed analytical data.

---

## 2. Transform

The raw datasets were cleaned and transformed before loading into MySQL.

Major transformation activities included:

### Data Cleaning

- Handled missing values
- Removed unnecessary columns
- Standardized column names
- Converted timestamps to appropriate datetime types
- Converted numerical fields to suitable data types
- Handled duplicate records
- Validated primary and foreign key relationships
- Addressed database loading issues such as incompatible data types and constraint violations

### Data Preparation

- Prepared customer, product, seller, order and review datasets
- Created relationships between transactional and dimensional entities
- Prepared sales-level data for analytical queries
- Created date-related attributes for time-based analysis
- Prepared data for Power BI reporting

---

## 3. Load

The transformed data was loaded into a MySQL database named:

```text
RetailDW
```

Python was used with SQLAlchemy to load the transformed datasets into MySQL.

Conceptually:

```python
from sqlalchemy import create_engine

engine = create_engine(
    "mysql+pymysql://username:password@localhost/RetailDW"
)

df.to_sql(
    "table_name",
    con=engine,
    if_exists="append",
    index=False
)
```

The final database provides a centralized source for SQL analytics and Power BI.

---

# 🗄️ Data Warehouse Design

The project uses a dimensional/star-schema-oriented design to separate transactional facts from descriptive dimensions.

### Fact tables

Examples include:

- `fact_sales`
- `fact_review`

### Dimension tables

Examples include:

- `dim_customer`
- `dim_product`
- `dim_seller`
- `dim_date`

The model enables analysis across:

- Time
- Customers
- Products
- Sellers
- Geography
- Reviews

---

# 📊 SQL Analytics

After loading the data into MySQL, SQL was used to answer business questions.

Examples include:

### Sales Performance

- Monthly revenue
- Revenue by state
- Order volume over time
- Average order value
- Top-selling products
- Top product categories

### Customer Analytics

- Total customers
- Repeat customers
- Customer purchasing behavior
- Top customers by revenue

### Seller Analytics

- Top sellers by revenue
- Seller order volume
- Seller performance comparison

### Product Analytics

- Best-selling categories
- Product-level sales
- Revenue contribution by category

### Operational Analytics

- Delivery time
- Order status distribution
- Review score analysis

SQL techniques used include:

- Aggregations
- `GROUP BY`
- `JOIN`
- `CASE`
- CTEs
- Window functions
- Subqueries
- Date-based analysis
- Views
- Stored procedures
- Query optimization/performance tuning

---

# 📈 Power BI Dashboard

The transformed MySQL data was connected to Power BI to create an interactive business dashboard.

## Dashboard Features

### KPI Cards

The dashboard includes:

- Total Orders
- Total Revenue
- Total Customers
- Products Sold
- Average Review Score

KPI cards also include comparison against the previous selected period.

---

## Sales Trend

A combined line and clustered column chart displays:

- Monthly Revenue
- Monthly Order Count

This helps identify sales growth and changes in order volume over time.

---

## Order Status Analysis

A donut chart shows the distribution of orders across statuses such as:

- Delivered
- Canceled
- Unavailable
- Invoiced
- Processing
- Shipped

---

## Customer Segmentation

Customers are segmented into:

- New Customers
- Repeat Customers

The dashboard supports date filtering so customer behavior can be analyzed for a selected period.

---

## Revenue by Region

A Brazil state-level map visualizes revenue geographically.

A Top 5 states chart highlights the highest-revenue customer states.

---

## Product Category Satisfaction

Average review score is analyzed by product category to identify categories with stronger customer satisfaction.

---

## Delivery Time Analysis

A histogram-style column chart shows the distribution of delivery duration in days.

This helps identify the typical delivery window and long-delivery outliers.

---

## Interactive Date Filtering

A date slicer allows users to select a custom date range.

An **All Dates** bookmark/button resets the dashboard to the full dataset period.

---

# 💡 Business Insights Enabled

The dashboard allows business users to answer questions such as:

- How much revenue is being generated?
- How are sales changing over time?
- Which states generate the most revenue?
- Which product categories perform best?
- How many customers are repeat purchasers?
- Which sellers generate the most revenue?
- How satisfied are customers with different product categories?
- What is the typical delivery time?
- How does performance change between two selected periods?

---

# 🔍 Data Validation

The project also validates analytical results between MySQL and Power BI.

For example, customer segmentation and selected-period customer counts were cross-checked against SQL calculations to ensure that dashboard metrics matched the underlying data.

This validation step helps prevent incorrect business conclusions caused by filtering or data-model issues.

---

# 📁 Suggested Project Structure

```text
olist-ecommerce-analytics/
│
├── data/
│   └── raw/
│
├── etl/
│   ├── extract.py
│   ├── transform.py
│   ├── load_to_mysql.py
│   └── pipeline.py
│
├── sql/
│   ├── schema.sql
│   ├── analytics.sql
│   └── views.sql
│
├── powerbi/
│   └── Olist_Analytics.pbix
│
├── notebooks/
│   └── data_exploration.ipynb
│
├── README.md
└── requirements.txt
```

---

# 🚀 End-to-End Workflow

```text
1. Collect raw Olist CSV datasets
          ↓
2. Extract data using Python/Pandas
          ↓
3. Clean and transform datasets
          ↓
4. Validate data types and relationships
          ↓
5. Load transformed data into MySQL
          ↓
6. Build/query the RetailDW warehouse
          ↓
7. Perform SQL business analytics
          ↓
8. Connect MySQL to Power BI
          ↓
9. Build dimensional model in Power BI
          ↓
10. Create DAX measures and KPIs
          ↓
11. Build interactive visualizations
          ↓
12. Validate Power BI results against MySQL
          ↓
13. Deliver business-ready dashboard
```

---

# 🎯 Project Outcome

This project demonstrates an end-to-end **Data Engineering + SQL Analytics + Business Intelligence** workflow.

It converts raw e-commerce data into a structured analytical system and provides an interactive Power BI dashboard for monitoring sales, customers, products, sellers, reviews, geography, and delivery performance.

The project demonstrates practical experience with:

**ETL → Data Warehousing → SQL Analytics → Data Modeling → DAX → Power BI Visualization → Business Insights**

---
