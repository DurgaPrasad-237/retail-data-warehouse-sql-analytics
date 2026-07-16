use retaildw;

/* =============================== 
Basic Analysis
==================================*/

-- find the total number of Customers
select count(distinct customer_unique_id) from customers;


-- Find the total number of orders
select count(*) from orders;


-- find the total number of products 
select count(*) from products;


-- find the total number of sellers
select count(*) from sellers;


-- find the product sales revnue
select Round(sum(price),1) as product_revnue
from order_items;


-- total cusstomer payment
SELECT
ROUND(SUM(payment_value),2) AS Customer_Payments
FROM Payments;

-- shipping revenue
SELECT
ROUND(SUM(freight_value),2) AS Freight_Revenue
FROM Order_Items;	


-- SELECT
--     oi.order_id,
--     SUM(oi.price + oi.freight_value) AS order_total,
--     SUM(op.payment_value) AS payment_total,
--     SUM(op.payment_value) - SUM(oi.price + oi.freight_value) AS difference
-- FROM Order_Items oi
-- JOIN Payments op
--     ON oi.order_id = op.order_id
-- GROUP BY oi.order_id
-- HAVING ABS(difference) > 0.01
-- LIMIT 20;


-- SELECT
--     oi.order_id,
--     oi.order_total,
--     p.payment_total,
--     p.payment_total - oi.order_total AS difference
-- FROM
-- (
--     SELECT
--         order_id,
--         SUM(price + freight_value) AS order_total
--     FROM Order_Items
--     GROUP BY order_id
-- ) oi
-- JOIN
-- (
--     SELECT
--         order_id,
--         SUM(payment_value) AS payment_total
--     FROM Payments
--     GROUP BY order_id
-- ) p
-- ON oi.order_id = p.order_id
-- WHERE ABS(p.payment_total - oi.order_total) > 0.01;

