# Retail Sales Data Warehouse & SQL Analytics

## Project Overview

This project demonstrates the complete development of a retail sales analytics database using the Brazilian Olist E-Commerce dataset.

The project covers the end-to-end data engineering workflow, including data extraction, cleaning, ETL, database design, data validation, and advanced SQL analysis. The objective is to transform raw transactional data into a structured relational database that supports business analytics and reporting.

---

## Business Problem

Retail businesses generate large volumes of transactional data from customers, orders, products, payments, sellers, and reviews. Managing and analyzing this data efficiently requires a well-designed relational database and optimized SQL queries.

This project focuses on building a centralized database capable of answering key business questions related to sales, customers, products, payments, and delivery performance.

---

## Dataset

**Dataset:** Brazilian E-Commerce Public Dataset by Olist

The dataset contains approximately **100,000 e-commerce orders** with information about:

- Customers
- Orders
- Order Items
- Products
- Sellers
- Payments
- Reviews
- Product Categories
- Geolocation

---

## Technologies Used

- Python
- Pandas
- MySQL
- SQLAlchemy
- MySQL Workbench
- SQL
- Git
- GitHub

---

## Project Workflow

```
Raw CSV Files
        │
        ▼
Python ETL
        │
        ▼
Data Cleaning
        │
        ▼
Data Validation
        │
        ▼
MySQL Database
        │
        ▼
Advanced SQL Analysis
```

---

## Database Design

Designed a normalized relational database consisting of:

- Customers
- Orders
- Order Items
- Products
- Sellers
- Payments
- Reviews
- Product Category Translation
- Geolocation

Implemented:

- Primary Keys
- Foreign Keys
- Constraints
- Relationships

---

## ETL Pipeline

The ETL pipeline was developed using Python and Pandas.

### Extract

- Loaded all CSV files from the Olist dataset.

### Transform

- Checked missing values
- Removed duplicate records
- Converted appropriate data types
- Prepared data for loading into MySQL

### Load

- Connected Python to MySQL using SQLAlchemy.
- Loaded all cleaned datasets into their corresponding relational tables.

---

## Data Validation

Performed validation after loading the data into MySQL.

Validation included:

- Row count validation
- Duplicate validation
- NULL value validation
- Primary Key validation
- Foreign Key validation
- Data type validation
- Business rule validation

During validation, 99.7% of customer payment records matched the corresponding order totals, with only a small percentage showing minor differences due to the characteristics of the original dataset.

---

## SQL Analysis

Performed business-oriented SQL analysis covering multiple business domains.

### Sales Analysis

- Total Revenue
- Monthly Revenue
- Revenue by Product Category
- Revenue by State
- Revenue by Seller
- Average Order Value

### Customer Analysis

- Customer Lifetime Value
- Repeat Customers
- One-Time Customers
- Customer Distribution
- Average Customer Spending

### Product Analysis

- Top Selling Products
- Top Selling Categories
- Products Never Sold
- Category Performance

### Payment Analysis

- Payment Method Distribution
- Installment Analysis
- Payment Trends
- Customer Payment Analysis

### Delivery Analysis

- Average Delivery Time
- Delayed Deliveries
- Delivery Performance

### Review Analysis

- Average Review Score
- Highest Rated Products
- Lowest Rated Products
- Seller Ratings

Advanced SQL concepts used:

- Joins
- CTEs
- Window Functions
- CASE Statements
- Aggregate Functions
- Subqueries
- Views

---

## Repository Structure

```
Retail-Sales-Analytics/

│

├── dataset/

├── sql/
│   ├── schema.sql
│   ├── load_validation.sql
│   ├── sales_analysis.sql
│   ├── customer_analysis.sql
│   ├── product_analysis.sql
│   ├── payment_analysis.sql
│   ├── delivery_analysis.sql
│   ├── review_analysis.sql
|   ├── storedprocedure.sql


├── python/
│   ├── validations.py
│   ├── load_to_mysql.py

├── README.md
```

---

## Skills Demonstrated

- Relational Database Design
- ETL Pipeline Development
- Data Cleaning
- Data Validation
- Advanced SQL
- Database Normalization
- Business Analytics
- MySQL
- Python
- SQLAlchemy

---

## Future Enhancements

- Query Performance Optimization using EXPLAIN
- Indexing Strategy
- Interactive Power BI Dashboard

- Automated ETL Pipeline
- Cloud Database Deployment
