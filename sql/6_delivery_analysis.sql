use retaildw;

-- averge delivery time in days
SELECT
    ROUND(AVG(DATEDIFF(order_delivered_customer_date,
                       order_purchase_timestamp)),2) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

-- fasterse delived orders
SELECT
    order_id,
    DATEDIFF(order_delivered_customer_date,
             order_purchase_timestamp) AS delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
ORDER BY delivery_days ASC
LIMIT 10;

-- slowest delevired orders
SELECT
    order_id,
    DATEDIFF(order_delivered_customer_date,
             order_purchase_timestamp) AS delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
ORDER BY delivery_days DESC
LIMIT 10;

-- orders delivered after estimated date
SELECT
    COUNT(*) AS late_deliveries
FROM orders
WHERE order_delivered_customer_date >
      order_estimated_delivery_date;
      
-- order delivered before estimated date
SELECT
    COUNT(*) AS early_deliveries
FROM orders
WHERE order_delivered_customer_date <
      order_estimated_delivery_date;
      
-- average freight cost
SELECT
    ROUND(AVG(freight_value),2) AS avg_freight_cost
FROM order_items;


-- freight cost by customer state
SELECT
    c.customer_state,
    ROUND(AVG(oi.freight_value),2) AS avg_freight_cost
FROM order_items oi
JOIN orders o
ON oi.order_id = o.order_id
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY avg_freight_cost DESC;


-- delivery performance by seller
SELECT
    oi.seller_id,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date,
                       o.order_purchase_timestamp)),2) AS avg_delivery_days
FROM order_items oi
JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY oi.seller_id
ORDER BY avg_delivery_days;


-- top 10 fastest sellers
SELECT
    oi.seller_id,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date,
                       o.order_purchase_timestamp)),2) AS avg_delivery_days
FROM order_items oi
JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY oi.seller_id
ORDER BY avg_delivery_days ASC
LIMIT 10;

-- top 10 slowest sellers
SELECT
    oi.seller_id,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date,
                       o.order_purchase_timestamp)),2) AS avg_delivery_days
FROM order_items oi
JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY oi.seller_id
ORDER BY avg_delivery_days DESC
LIMIT 10;