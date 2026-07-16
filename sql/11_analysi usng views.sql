use retaildw;

-- vw montly analysis
CREATE VIEW vw_monthly_sales AS
SELECT
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month,
    MONTHNAME(o.order_purchase_timestamp) AS month_name,
    SUM(oi.price) AS revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    MONTHNAME(o.order_purchase_timestamp);
    
SELECT * FROM vw_monthly_sales;


-- vw customer summary
CREATE VIEW vw_customer_summary AS
SELECT
    c.customer_unique_id,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(p.payment_value) AS total_spending,
    AVG(p.payment_value) AS avg_order_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN payments p
ON o.order_id = p.order_id
GROUP BY
    c.customer_unique_id,
    c.customer_state;
    
SELECT * FROM vw_customer_summary;

-- product performance
CREATE VIEW vw_product_performance AS
SELECT
    p.product_id,
    p.product_category_name,
    COUNT(oi.order_id) AS units_sold,
    SUM(oi.price) AS revenue,
    AVG(r.review_score) AS avg_review_score
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
LEFT JOIN reviews r
ON oi.order_id = r.order_id
GROUP BY
    p.product_id,
    p.product_category_name;
    
SELECT * FROM vw_product_performance;


-- vw delviery analysi
CREATE VIEW vw_delivery_analysis AS
SELECT
    o.order_id,
    c.customer_state,
    DATEDIFF(
        o.order_delivered_customer_date,
        o.order_purchase_timestamp
    ) AS delivery_days,
    DATEDIFF(
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date
    ) AS delay_days,
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
        THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL;

SELECT * FROM vw_delivery_analysis;

-- payment summary
CREATE VIEW vw_payment_summary AS
SELECT
    payment_type,
    COUNT(order_id) AS total_orders,
    SUM(payment_value) AS total_revenue,
    AVG(payment_value) AS avg_payment
FROM payments
GROUP BY payment_type;

SELECT * FROM vw_payment_summary;

