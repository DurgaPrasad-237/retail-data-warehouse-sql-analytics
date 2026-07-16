use retaildw;

-- top selling categories by units sold
SELECT
    p.product_category_name,
    COUNT(oi.product_id) AS units_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY units_sold DESC
LIMIT 10;

-- least selling categories
SELECT
    p.product_category_name,
    COUNT(oi.product_id) AS units_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY units_sold ASC
LIMIT 10;

-- products wiht highest revenue
SELECT
    oi.product_id,
    SUM(oi.price) AS revenue
FROM order_items oi
GROUP BY oi.product_id
ORDER BY revenue DESC
LIMIT 10;

-- products never sold
SELECT
    p.product_id,
    p.product_category_name
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- avg product price categor
SELECT
    p.product_category_name,
    AVG(oi.price) AS avg_price
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY avg_price DESC;

-- most expensive product
SELECT
    product_id,
    MAX(price) AS highest_price
FROM order_items
GROUP BY product_id
ORDER BY highest_price DESC
LIMIT 10;

-- chepeast product
SELECT
    product_id,
    MIN(price) AS lowest_price
FROM order_items
GROUP BY product_id
ORDER BY lowest_price ASC
LIMIT 10;

-- products score review by category
SELECT
    p.product_category_name,
    AVG(r.review_score) AS avg_review_score
FROM reviews r
JOIN orders o
ON r.order_id = o.order_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_review_score DESC;