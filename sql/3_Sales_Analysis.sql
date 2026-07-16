use retaildw;

-- monthly sles revenue
select monthname(orders.order_purchase_timestamp) as mnt, year(orders.order_purchase_timestamp) as yr,
sum(order_items.price) as sales from orders
join order_items on orders.order_id = order_items.order_id
group by yr , mnt ,  month(orders.order_purchase_timestamp)
order by yr asc, month(orders.order_purchase_timestamp) asc;

-- monthly order count
select monthname(orders.order_purchase_timestamp) as mnt, year(orders.order_purchase_timestamp) as yr, 
count(*) as cnr from orders
group by yr,mnt, month(orders.order_purchase_timestamp)
order by yr asc, month(orders.order_purchase_timestamp) asc;

-- average order values
SELECT AVG(order_total) AS avg_order_value
FROM (
    SELECT order_id, SUM(price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS t;


-- highest revenue month
SELECT
    MONTHNAME(orders.order_purchase_timestamp) AS mnt,
    YEAR(orders.order_purchase_timestamp) AS yr,
    SUM(order_items.price) AS revenue
FROM orders
JOIN order_items
    ON orders.order_id = order_items.order_id
GROUP BY
    YEAR(orders.order_purchase_timestamp),
    MONTHNAME(orders.order_purchase_timestamp)
ORDER BY
    revenue DESC
LIMIT 1;

-- top 10 highest selling product by revenue
SELECT
    p.product_category_name,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;

-- top 10 producs number of unit sold
SELECT
    p.product_category_name,
    COUNT(oi.product_id) AS units_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY units_sold DESC
LIMIT 10;

-- revenue by seller
select seller_id,sum(price) as revenue from order_items
group by seller_id;

-- revenue by custoemr state
select c.customer_state,sum(oi.price) as revenue from order_items as oi
join orders as o on oi.order_id = o.order_id
join customers as c on o.customer_id = c.customer_id
group by c.customer_state
order by revenue desc;

-- revenue by payment type
SELECT
    p.payment_type,
    SUM(p.payment_value) AS revenue
FROM payments p
GROUP BY p.payment_type
ORDER BY revenue DESC;
