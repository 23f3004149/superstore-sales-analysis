
CREATE DATABASE superstore

CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(20),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(10),
    region VARCHAR(20)
);
CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
	category VARCHAR(20),
	sub_category VARCHAR(20),
	product_name VARCHAR(200)
);
CREATE TABLE orders(
    order_id VARCHAR(20) PRIMARY KEY,
	order_date DATE NOT NULL,
	ship_date DATE NOT NULL,
	ship_mode VARCHAR(20),
	customer_id VARCHAR(20) REFERENCES customers(customer_id)
);
CREATE TABLE order_details(
    id SERIAL PRIMARY KEY,
	order_id VARCHAR(20) REFERENCES orders(order_id),
	product_id VARCHAR(20) REFERENCES products(product_id),
	sales FLOAT NOT NULL,
	quantity INT NOT NULL,
	discount NUMERIC(5,2) DEFAULT 0,
	profit NUMERIC(10,2)
);
CREATE TABLE staging_superstore (
    row_id INT,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(20),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(20),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(10),
    region VARCHAR(20),
    product_id VARCHAR(20),
    category VARCHAR(20),
    sub_category VARCHAR(20),
    product_name VARCHAR(200),
    sales NUMERIC(10,2),
    quantity INT,
    discount NUMERIC(5,2),
    profit NUMERIC(10,2)
);