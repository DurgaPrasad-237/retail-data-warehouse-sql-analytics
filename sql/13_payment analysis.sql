use retaildw;

-- payemtn metod distribution
SELECT
    payment_type,
    COUNT(*) AS total_payments
FROM payments
GROUP BY payment_type
ORDER BY total_payments DESC;

-- reveneu by payemtn method
SELECT
    payment_type,
    SUM(payment_value) AS revenue
FROM payments
GROUP BY payment_type
ORDER BY revenue DESC;

-- avg installmetn count
SELECT
    ROUND(AVG(payment_installments),2) AS avg_installments
FROM payments;

-- orders wiht multipel installmetns
SELECT
    order_id,
    payment_installments,
    payment_value
FROM payments
WHERE payment_installments > 1
ORDER BY payment_installments DESC;

-- higehst paymetn amount
SELECT
    order_id,
    payment_type,
    payment_value
FROM payments
ORDER BY payment_value DESC
LIMIT 1;

-- lowest payemtn amount
SELECT
    order_id,
    payment_type,
    payment_value
FROM payments
ORDER BY payment_value ASC
LIMIT 1;

-- avverage payment
SELECT
    ROUND(AVG(payment_value),2) AS avg_payment
FROM payments;

-- payment success analysis
SELECT
    p.payment_type,
    COUNT(*) AS successful_orders,
    SUM(p.payment_value) AS revenue
FROM payments p
JOIN orders o
ON p.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY p.payment_type
ORDER BY successful_orders DESC;