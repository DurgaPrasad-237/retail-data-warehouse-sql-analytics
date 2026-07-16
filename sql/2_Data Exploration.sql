use retaildw;

-- count orders by status
select order_status,count(*) as cnt from orders
group by order_status
order by cnt desc;

-- number of products in each category
select product_category_name,count(*) as cnt from products
group by product_category_name
order by cnt desc;


-- number of sellers by state
select seller_state,count(*) as cnt from sellers
group by seller_state
order by cnt desc;

-- number of custoemrs by state
select customer_state,count(*) as cnt from customers
group by customer_state
order by cnt desc;

-- distince payment methods used
select distinct payment_type from payments;
