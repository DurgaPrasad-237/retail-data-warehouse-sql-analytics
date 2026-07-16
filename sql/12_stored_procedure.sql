use retaildw;

-- monthly revenue report
DELIMITER //

CREATE PROCEDURE sp_monthly_revenue_report()
BEGIN
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
        MONTHNAME(o.order_purchase_timestamp)
    ORDER BY year, month;
END //

DELIMITER ;
CALL sp_monthly_revenue_report();


-- custome purchase history
DELIMITER //

CREATE PROCEDURE sp_customer_purchase_history
(
    IN customerId VARCHAR(50)
)
BEGIN
    SELECT
        o.order_id,
        o.order_purchase_timestamp,
        p.payment_value,
        o.order_status
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN payments p
        ON o.order_id = p.order_id
    WHERE c.customer_unique_id = customerId
    ORDER BY o.order_purchase_timestamp;
END //

DELIMITER ;

CALL sp_customer_purchase_history('248ffe10d632bebe4f7267f1f44844c9');

-- products sales report
DELIMITER //

CREATE PROCEDURE sp_product_sales_report()
BEGIN
    SELECT
        p.product_id,
        p.product_category_name,
        COUNT(oi.order_id) AS units_sold,
        SUM(oi.price) AS revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_category_name
    ORDER BY revenue DESC;
END //

DELIMITER ;

CALL sp_product_sales_report();

-- sales performace report
DELIMITER //

CREATE PROCEDURE sp_seller_performance_report()
BEGIN
    SELECT
        s.seller_id,
        s.seller_state,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        SUM(oi.price) AS revenue,
        ROUND(AVG(r.review_score),2) AS avg_rating
    FROM sellers s
    JOIN order_items oi
        ON s.seller_id = oi.seller_id
    LEFT JOIN reviews r
        ON oi.order_id = r.order_id
    GROUP BY
        s.seller_id,
        s.seller_state
    ORDER BY revenue DESC;
END //

DELIMITER ;

CALL sp_seller_performance_report();

-- category revenue report
DELIMITER //

CREATE PROCEDURE sp_category_revenue_report()
BEGIN
    SELECT
        p.product_category_name,
        SUM(oi.price) AS revenue,
        COUNT(oi.order_id) AS units_sold,
        ROUND(AVG(r.review_score),2) AS avg_review
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    LEFT JOIN reviews r
        ON oi.order_id = r.order_id
    GROUP BY
        p.product_category_name
    ORDER BY revenue DESC;
END //

DELIMITER ;

CALL sp_category_revenue_report();