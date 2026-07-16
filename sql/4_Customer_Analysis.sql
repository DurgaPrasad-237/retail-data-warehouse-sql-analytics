use retaildw;

-- top 10 customeres by spending value
select c.customer_unique_id,sum(oi.price) as revenue from order_items as oi
join orders as o on oi.order_id = o.order_id
join customers as c on o.customer_id = c.customer_id
group by c.customer_unique_id
order by revenue desc
LIMIT 10;

-- custoemr live time value 
SELECT
    c.customer_unique_id,
    SUM(p.payment_value) AS customer_lifetime_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY customer_lifetime_value DESC;


-- repeat customers
SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;


-- one time custoemrs
SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) = 1
ORDER BY total_orders DESC;

-- average order per customer
SELECT
    AVG(order_count) AS avg_orders_per_customer
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) t;

-- average spending per customer
SELECT
    AVG(total_spending) AS avg_spending_per_customer
FROM (
    SELECT
        c.customer_unique_id,
        SUM(p.payment_value) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY c.customer_unique_id
) t;

-- customer wiht highest averge order value
SELECT
    c.customer_unique_id,
    AVG(p.payment_value) AS avg_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY avg_order_value DESC
LIMIT 10;

-- new customers by month
SELECT
    YEAR(first_order_date) AS year,
    MONTHNAME(first_order_date) AS month,
    COUNT(*) AS new_customers
FROM (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_order_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) t
GROUP BY
    YEAR(first_order_date),
    MONTH(first_order_date),
    MONTHNAME(first_order_date)
ORDER BY
    YEAR(first_order_date),
    MONTH(first_order_date);


-- customer distribution by state
SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS customers
FROM customers
GROUP BY customer_state
ORDER BY customers DESC;

-- top cicites by custoemr count
SELECT
    customer_city,
    COUNT(DISTINCT customer_unique_id) AS customers
FROM customers
GROUP BY customer_city
ORDER BY customers DESC
LIMIT 10;

-- repeat custoemr rate
SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        c.customer_unique_id
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) > 1
) t;