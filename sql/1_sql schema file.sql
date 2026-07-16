DROP DATABASE IF EXISTS RetailDW;
CREATE DATABASE RetailDW;
USE RetailDW;

create table customers(
	customer_id varchar(50) primary key,
    customer_unique_id varchar(50) unique,
    customer_zip_code_prefix int(9),
    customer_city varchar(25),
    customer_state varchar(5)
);

create table location(
	geolocation_zip_code_prefix int(7),
	geolocation_lat DECIMAL(10,7),
    geolocation_lng DECIMAL(10,7),
    geolocation_city varchar(25),
    geolocation_state varchar(5)
);

create table orderes(
	order_id varchar(50) primary key,
    customer_id varchar(50),
    order_status varchar(20),
    order_purchase_timestamp timestamp,
    order_approved_at timestamp,
    order_delivered_carrier_date timestamp,
    order_delivered_customer_date timestamp,
    order_estimated_delivery_date timestamp,
    foreign key (customer_id) references customers(customer_id)
);

alter table orderes rename to orders;

create table products(
	product_id varchar(50) primary key,
    product_category_name varchar(25),
    product_name_lenght int(5),
    product_description_lenght int(5),
    product_photos_qty int(5),
    product_weight_g decimal(5,4),
    product_length_cm decimal(5,4),
    product_height_cm decimal(5,4),
    product_width_cm decimal(5,4)
);

create table sellers(
	seller_id varchar(50) primary key,
    seller_zip_code_prefix int(7),
    seller_city varchar(25),
    seller_state varchar(5)
);

create table product_category(
	product_category_name varchar(50) primary key,
    product_category_name_english varchar(50)
);

drop table if exists order_items;
create table order_items (
	order_id varchar(50),
    order_item_id varchar(4),
    product_id varchar(50),
    seller_id varchar(50),
    shipping_limit_date timestamp,
    price decimal(5,3),
    freight_value decimal(5,3),
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id),
    foreign key (seller_id) references sellers(seller_id)
);

create table payments(
	order_id varchar(50),
    payment_sequential varchar(3),
    payment_type varchar(20),
    payment_installments int(3),
    payment_value decimal(5,3),
	foreign key (order_id) references orders(order_id)
);

create table reviews(
	review_id varchar(50) primary key,
    order_id varchar(50),
    review_score int(2),
    review_comment_title varchar(20),
    review_comment_message varchar(250),
    review_creation_date timestamp,
    review_answer_timestamp timestamp,
    foreign key (order_id) references orders(order_id)
);

ALTER TABLE Customers
DROP INDEX customer_unique_id;
select count(*) from customers;


CREATE INDEX idx_orders_customer
ON Orders(customer_id);

CREATE INDEX idx_orders_status
ON Orders(order_status);

CREATE INDEX idx_orders_purchase
ON Orders(order_purchase_timestamp);

CREATE INDEX idx_orderitems_product
ON Order_Items(product_id);

CREATE INDEX idx_orderitems_seller
ON Order_Items(seller_id);

CREATE INDEX idx_payments_type
ON Payments(payment_type);

CREATE INDEX idx_reviews_score
ON Reviews(review_score);

CREATE INDEX idx_products_category
ON Products(product_category_name);

ALTER TABLE Customers
MODIFY customer_city VARCHAR(100);

ALTER TABLE sellers
MODIFY seller_city VARCHAR(100);

select count(*) from customers;

ALTER TABLE location
MODIFY geolocation_city VARCHAR(100);

SELECT COUNT(*) FROM Products;

describe products;

ALTER TABLE Products
MODIFY product_weight_g INT,
MODIFY product_length_cm DECIMAL(10,2),
MODIFY product_height_cm DECIMAL(10,2),
MODIFY product_width_cm DECIMAL(10,2);

ALTER TABLE order_items
Modify price decimal(10,3),
modify freight_value decimal(10,3);

ALTER TABLE payments
Modify payment_value decimal(10,3);

ALTER TABLE reviews
Modify review_comment_title varchar(30);

ALTER TABLE Products
MODIFY product_category_name VARCHAR(100);

ALTER TABLE Reviews
DROP PRIMARY KEY;

ALTER TABLE Reviews
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;

ALTER TABLE location
ADD COLUMN location_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

select * from location;

describe location;

ALTER TABLE order_items
ADD COLUMN order_items_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

ALTER TABLE payments
ADD COLUMN payments_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

describe reviews;

select count(*) from order_items;

ALTER TABLE order_items
ADD CONSTRAINT uk_order_item
UNIQUE (order_id, order_item_id);

ALTER TABLE payments
ADD CONSTRAINT uk_payment
UNIQUE (order_id, payment_sequential);

ALTER TABLE location
ADD CONSTRAINT uk_location
UNIQUE (
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
);

truncate location;
truncate order_items;
truncate payments;

ALTER TABLE payments
MODIFY payments_id INT;

ALTER TABLE payments
DROP PRIMARY KEY;

ALTER TABLE order_items
MODIFY order_items_id INT;

ALTER TABLE order_items
DROP PRIMARY KEY;

ALTER TABLE location
MODIFY location_id INT;

ALTER TABLE location
DROP PRIMARY KEY;

select count(*) from location;
select count(*) from payments;
select count(*) from order_items;

ALTER TABLE location 
DROP COLUMN location_id;

ALTER TABLE payments 
DROP COLUMN payments_id;

ALTER TABLE order_items 
DROP COLUMN order_items_id;

select * from location;

show create table order_items;

ALTER TABLE location 
DROP INDEX uk_location;


ALTER TABLE order_items
ADD PRIMARY KEY (order_id, order_item_id);

ALTER TABLE payments
ADD PRIMARY KEY (order_id, payment_sequential);

select count(*) from reviews;

ALTER TABLE reviews
MODIFY id INT;

ALTER TABLE reviews
DROP PRIMARY KEY;

ALTER TABLE reviews 
DROP COLUMN id;

ALTER TABLE reviews
ADD PRIMARY KEY (review_id, order_id);

ALTER TABLE location 
DROP COLUMN location_id;

select count(*) from location;





