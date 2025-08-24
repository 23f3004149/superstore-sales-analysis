
COPY staging_superstore
FROM 'D:\Projects\superstore-sales-analysis\dataset\Superstore.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO customers (customer_id, customer_name, segment, country, city, state, postal_code, region)
SELECT customer_id, customer_name, segment, country, city, state, postal_code, region
FROM (
    SELECT *,ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY customer_name) AS rn
    FROM staging_superstore
) t
WHERE rn = 1;

INSERT INTO products (product_id, category, sub_category, product_name)
SELECT product_id, category, sub_category, product_name
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY product_id) AS rn
	FROM staging_superstore
) t 
WHERE rn = 1;

INSERT INTO orders (order_id, order_date, ship_date, ship_mode, customer_id)
SELECT 
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id
FROM (
    SELECT *,ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY order_date) AS rn
	from staging_superstore
) t 
WHERE rn = 1

INSERT INTO order_details (order_id, product_id, sales, quantity, discount, profit)
SELECT order_id, product_id, sales, quantity, discount, profit
FROM staging_superstore;


SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_details;
