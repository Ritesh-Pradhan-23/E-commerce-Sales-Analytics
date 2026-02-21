use project;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers (customer_id, customer_name, city, signup_date)
SELECT 
    n,
    CONCAT('Customer_', n),
    ELT((n % 5) + 1, 'New York', 'London', 'Berlin', 'Paris', 'Tokyo'),
    DATE_ADD('2023-01-01', INTERVAL n DAY)
FROM (
    SELECT a.n + b.n * 10 + 1 AS n
    FROM 
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) b
) nums
WHERE n <= 50;

INSERT INTO products (product_id, product_name, category, price)
SELECT 
    n,
    CONCAT('Product_', n),
    ELT((n % 4) + 1, 'Electronics', 'Clothing', 'Home', 'Books'),
    ROUND(50 + (n * 15.5), 2)
FROM (
    SELECT a.n + b.n * 10 + 1 AS n
    FROM 
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1) b
) nums
WHERE n <= 20;

INSERT INTO orders (order_id, customer_id, order_date, status)
SELECT
    n,
    (n % 50) + 1,
    DATE_ADD('2023-02-01', INTERVAL n DAY),
    ELT((n % 3) + 1, 'Completed', 'Cancelled', 'Pending')
FROM (
    SELECT a.n + b.n * 10 + 1 AS n
    FROM 
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
) nums
WHERE n <= 100;

INSERT INTO order_items (order_item_id, order_id, product_id, quantity)
SELECT
    n,
    (n % 100) + 1,
    (n % 20) + 1,
    (n % 5) + 1
FROM (
    SELECT a.n + b.n * 10 + 1 AS n
    FROM 
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
) nums
WHERE n <= 200;

SELECT 'customers' table_name, COUNT(*) FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items;
