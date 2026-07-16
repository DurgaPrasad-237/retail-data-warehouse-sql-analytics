use retaildw;

-- rank customers by spending
SELECT
    c.customer_unique_id,
    SUM(p.payment_value) AS spending,
    RANK() OVER (ORDER BY SUM(p.payment_value) DESC) AS customer_rank
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN payments p
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id;

-- dense rank by revnue
SELECT
    product_id,
    revenue,
    DENSE_RANK() OVER (ORDER BY revenue DESC) AS product_rank
FROM
(
    SELECT
        product_id,
        SUM(price) AS revenue
    FROM order_items
    GROUP BY product_id
) t;

-- running monthly revenue
SELECT
    yr,
    mnth,
    revenue,
    SUM(revenue) OVER
    (
        ORDER BY yr,mnth
    ) AS running_revenue
FROM
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS yr,
        MONTH(o.order_purchase_timestamp) AS mnth,
        SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY yr,mnth
) t;	


-- runnign total orders
SELECT
    yr,
    mnth,
    total_orders,
    SUM(total_orders) OVER
    (
        ORDER BY yr,mnth
    ) AS running_orders
FROM
(
    SELECT
        YEAR(order_purchase_timestamp) AS yr,
        MONTH(order_purchase_timestamp) AS mnth,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY yr,mnth
) t;

-- monthly move avg sales (3months)
SELECT
    yr,
    mnth,
    revenue,
    ROUND(
        AVG(revenue) OVER
        (
            ORDER BY yr,mnth
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),2
    ) AS moving_avg
FROM
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS yr,
        MONTH(o.order_purchase_timestamp) AS mnth,
        SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY yr,mnth
) t;

-- top 3 products in every category
SELECT
    product_category_name,
    product_id,
    revenue
FROM
(
    SELECT
        p.product_category_name,
        oi.product_id,
        SUM(oi.price) AS revenue,
        RANK() OVER
        (
            PARTITION BY p.product_category_name
            ORDER BY SUM(oi.price) DESC
        ) AS rnk
    FROM order_items oi
    JOIN products p
    ON oi.product_id = p.product_id
    GROUP BY p.product_category_name,oi.product_id
) t
WHERE rnk<=3;

-- top sellers in evvery state
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
        ) AS rnk
    FROM sellers s
    JOIN order_items oi
    ON s.seller_id=oi.seller_id
    GROUP BY s.seller_state,s.seller_id
) t
WHERE rnk=1;

-- previous month revnue using lag
SELECT
    yr,
    mnth,
    revenue,
    LAG(revenue) OVER
    (
        ORDER BY yr,mnth
    ) AS previous_month_revenue
FROM
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS yr,
        MONTH(o.order_purchase_timestamp) AS mnth,
        SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi
    ON o.order_id=oi.order_id
    GROUP BY yr,mnth
) t;

-- revenue gorwht rate usng lead
SELECT
    yr,
    mnth,
    revenue,
    LEAD(revenue) OVER
    (
        ORDER BY yr,mnth
    ) AS next_month_revenue,
    LEAD(revenue) OVER
    (
        ORDER BY yr,mnth
    ) - revenue AS growth
FROM
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS yr,
        MONTH(o.order_purchase_timestamp) AS mnth,
        SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi
    ON o.order_id=oi.order_id
    GROUP BY yr,mnth
) t;

-- Percent Contribution of Each Category to Total Revenue
SELECT
    product_category_name,
    revenue,
    ROUND(
        revenue*100/
        SUM(revenue) OVER (),
        2
    ) AS contribution_percent
FROM
(
    SELECT
        p.product_category_name,
        SUM(oi.price) AS revenue
    FROM products p
    JOIN order_items oi
    ON p.product_id=oi.product_id
    GROUP BY p.product_category_name
) t
ORDER BY contribution_percent DESC;