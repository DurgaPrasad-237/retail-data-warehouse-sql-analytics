use retaildw;

-- average review score
SELECT
    ROUND(AVG(review_score),2) AS avg_review_score
FROM reviews;

-- review score distriubtion
SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score;

-- highest rated categories
SELECT
    p.product_category_name,
    ROUND(AVG(r.review_score),2) AS avg_rating
FROM reviews r
JOIN order_items oi
ON r.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_rating DESC
LIMIT 10;

-- lowest rated categories
SELECT
    p.product_category_name,
    ROUND(AVG(r.review_score),2) AS avg_rating
FROM reviews r
JOIN order_items oi
ON r.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_rating ASC
LIMIT 10;

-- sellers average ratings
SELECT
    oi.seller_id,
    ROUND(AVG(r.review_score),2) AS avg_rating
FROM reviews r
JOIN order_items oi
ON r.order_id = oi.order_id
GROUP BY oi.seller_id
ORDER BY avg_rating DESC;

-- product wiht most review
SELECT
    oi.product_id,
    COUNT(r.review_id) AS total_reviews
FROM reviews r
JOIN order_items oi
ON r.order_id = oi.order_id
GROUP BY oi.product_id
ORDER BY total_reviews DESC
LIMIT 10;

-- custoemr who gave one star review
SELECT
    c.customer_unique_id,
    COUNT(*) AS one_star_reviews
FROM reviews r
JOIN orders o
ON r.order_id = o.order_id
JOIN customers c
ON o.customer_id = c.customer_id
WHERE r.review_score = 1
GROUP BY c.customer_unique_id
ORDER BY one_star_reviews DESC;


-- average review score by state
SELECT
    c.customer_state,
    ROUND(AVG(r.review_score),2) AS avg_review_score
FROM reviews r
JOIN orders o
ON r.order_id = o.order_id
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY avg_review_score DESC;