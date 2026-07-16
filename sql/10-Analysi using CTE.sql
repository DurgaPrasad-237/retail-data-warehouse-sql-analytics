use retildw;

-- custoemr spending above averaage
WITH customer_spending AS
(
    SELECT
        c.customer_unique_id,
        SUM(p.payment_value) AS spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY c.customer_unique_id
)

SELECT *
FROM customer_spending
WHERE spending >
(
    SELECT AVG(spending)
    FROM customer_spending
);

-- monthly revenue trends
WITH monthly_revenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS yr,
        MONTH(o.order_purchase_timestamp) AS mnth,
        SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY yr,mnth
)

SELECT *
FROM monthly_revenue
ORDER BY yr,mnth;

-- top 5 customers in each state
WITH customer_sales AS
(
    SELECT
        c.customer_state,
        c.customer_unique_id,
        SUM(p.payment_value) AS spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY c.customer_state,c.customer_unique_id
)

SELECT *
FROM
(
    SELECT *,
           RANK() OVER
           (
               PARTITION BY customer_state
               ORDER BY spending DESC
           ) rnk
    FROM customer_sales
) t
WHERE rnk<=5;

-- categores withd decling states
WITH monthly_category_sales AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS yr,
        MONTH(o.order_purchase_timestamp) AS mnth,
        p.product_category_name,
        SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY yr,mnth,p.product_category_name
)

SELECT *
FROM
(
    SELECT *,
           LAG(revenue) OVER
           (
               PARTITION BY product_category_name
               ORDER BY yr,mnth
           ) AS previous_revenue
    FROM monthly_category_sales
) t
WHERE revenue < previous_revenue;

-- highest selling product in each month
WITH monthly_product_sales AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS yr,
        MONTH(o.order_purchase_timestamp) AS mnth,
        oi.product_id,
        SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY yr,mnth,oi.product_id
)

SELECT *
FROM
(
    SELECT *,
           RANK() OVER
           (
               PARTITION BY yr,mnth
               ORDER BY revenue DESC
           ) rnk
    FROM monthly_product_sales
) t
WHERE rnk=1;

-- monthly customer growth
WITH first_purchase AS
(
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_order
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)

SELECT
    YEAR(first_order) AS yr,
    MONTH(first_order) AS mnth,
    COUNT(*) AS new_customers
FROM first_purchase
GROUP BY yr,mnth
ORDER BY yr,mnth;

-- repet custoemr analysis
WITH customer_orders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,
    total_orders
FROM customer_orders
WHERE total_orders > 1
ORDER BY total_orders DESC;

-- reveenue rankign using cte
WITH category_revenue AS
(
    SELECT
        p.product_category_name,
        SUM(oi.price) AS revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.product_category_name
)

SELECT
    product_category_name,
    revenue,
    RANK() OVER
    (
        ORDER BY revenue DESC
    ) AS revenue_rank
FROM category_revenue;