use retaildw;

-- customer with no order
SELECT
    c.customer_unique_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- seller wiht no sales
SELECT
    s.seller_id
FROM sellers s
LEFT JOIN order_items oi
ON s.seller_id = oi.seller_id
WHERE oi.order_id IS NULL;

-- products with no reviews
SELECT DISTINCT
    p.product_id
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
LEFT JOIN reviews r
ON oi.order_id = r.order_id
WHERE r.review_id IS NULL;

-- customer who spent above average
SELECT
    c.customer_unique_id,
    SUM(pay.payment_value) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN payments pay
ON o.order_id = pay.order_id
GROUP BY c.customer_unique_id
HAVING total_spent >
(
    SELECT AVG(customer_total)
    FROM
    (
        SELECT
            SUM(payment_value) AS customer_total
        FROM customers c
        JOIN orders o
        ON c.customer_id = o.customer_id
        JOIN payments p
        ON o.order_id = p.order_id
        GROUP BY c.customer_unique_id
    ) t
);

-- categoreis wiht above averaage revenue
SELECT
    p.product_category_name,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
HAVING revenue >
(
    SELECT AVG(category_revenue)
    FROM
    (
        SELECT
            SUM(price) AS category_revenue
        FROM order_items oi
        JOIN products p
        ON oi.product_id = p.product_id
        GROUP BY product_category_name
    ) t
);

-- order continas mroe than five items
SELECT
    order_id,
    COUNT(*) AS total_items
FROM order_items
GROUP BY order_id
HAVING COUNT(*) > 5;


-- average product per order
SELECT
    ROUND(AVG(product_count),2) AS avg_products_per_order
FROM
(
    SELECT
        order_id,
        COUNT(*) AS product_count
    FROM order_items
    GROUP BY order_id
) t;

-- top seller in each state
SELECT
    seller_state,
    seller_id,
    revenue
FROM
(
    SELECT
        s.seller_state,
        s.seller_id,
        SUM(oi.price) AS revenue,
        RANK() OVER
        (
            PARTITION BY s.seller_state
            ORDER BY SUM(oi.price) DESC
        ) rnk
    FROM sellers s
    JOIN order_items oi
    ON s.seller_id = oi.seller_id
    GROUP BY s.seller_state,s.seller_id
) t
WHERE rnk = 1;

-- most popular payment method in each state
SELECT
    customer_state,
    payment_type,
    total_orders
FROM
(
    SELECT
        c.customer_state,
        p.payment_type,
        COUNT(*) AS total_orders,
        RANK() OVER
        (
            PARTITION BY c.customer_state
            ORDER BY COUNT(*) DESC
        ) rnk
    FROM payments p
    JOIN orders o
    ON p.order_id = o.order_id
    JOIN customers c
    ON o.customer_id = c.customer_id
    GROUP BY c.customer_state,p.payment_type
) t
WHERE rnk = 1;

-- revenue contribtion in each state
SELECT
    p.product_category_name,
    ROUND(SUM(oi.price),2) AS revenue,
    ROUND(
        SUM(oi.price) /
        (
            SELECT SUM(price)
            FROM order_items
        ) * 100,
        2
    ) AS revenue_percentage
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;