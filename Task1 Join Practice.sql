-- JOIN QUERIES
-- ================================================

-- INNER JOIN: Customers who have placed orders
SELECT 
    c.customer_id,
    c.name,
    o.order_id,
    o.order_date,
    o.amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;
-- OUTPUT
-- 1	Alice	201	2024-12-10	300
-- 1	Alice	202	2024-12-15	150
-- 2	Bob	203	2025-01-05	450
-- 2	Bob	204	2025-01-20	200
-- 3	Charlie	205	2025-01-25	125.5
-- 3	Charlie	206	2025-02-01	320.75
-- 4	David	207	2025-02-10	210
-- 5	Eva	208	2025-02-15	180.25
-- 6	Frank	209	2025-02-20	400
-- 7	Grace	210	2025-02-25	275
-- 1	Alice	211	2025-03-01	500
-- 8	Hank	212	2025-03-05	220
-- 2	Bob	213	2025-03-10	135
-- 3	Charlie	214	2025-03-15	160

-- LEFT JOIN: All customers, with or without orders
SELECT 
    c.customer_id,
    c.name,
    o.order_id,
    o.order_date,
    o.amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
-- OUTPUT
-- 1	Alice	202	2024-12-15	150
-- 1	Alice	211	2025-03-01	500
-- 2	Bob	203	2025-01-05	450
-- 2	Bob	204	2025-01-20	200
-- 2	Bob	213	2025-03-10	135
-- 3	Charlie	205	2025-01-25	125.5
-- 3	Charlie	206	2025-02-01	320.75
-- 3	Charlie	214	2025-03-15	160
-- 4	David	207	2025-02-10	210
-- 5	Eva	208	2025-02-15	180.25
-- 6	Frank	209	2025-02-20	400
-- 7	Grace	210	2025-02-25	275
-- 8	Hank	212	2025-03-05	220
-- 9	Ivy			
-- 10	John			

-- RIGHT JOIN: All orders, even if customer is missing
SELECT 
    c.customer_id,
    c.name,
    o.order_id,
    o.order_date,
    o.amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;
-- OUTPUT
-- 1	Alice	202	2024-12-15	150
-- 1	Alice	211	2025-03-01	500
-- 2	Bob	203	2025-01-05	450
-- 2	Bob	204	2025-01-20	200
-- 2	Bob	213	2025-03-10	135
-- 3	Charlie	205	2025-01-25	125.5
-- 3	Charlie	206	2025-02-01	320.75
-- 3	Charlie	214	2025-03-15	160
-- 4	David	207	2025-02-10	210
-- 5	Eva	208	2025-02-15	180.25
-- 6	Frank	209	2025-02-20	400
-- 7	Grace	210	2025-02-25	275
-- 8	Hank	212	2025-03-05	220
-- 		215	2025-03-20	300

-- FULL OUTER JOIN: All customers + all orders (if DB supports)
-- NOTE: MySQL does not support FULL OUTER JOIN directly
-- Alternative for MySQL using UNION
SELECT 
    c.customer_id,
    c.name,
    o.order_id,
    o.order_date,
    o.amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id

UNION

SELECT 
    c.customer_id,
    c.name,
    o.order_id,
    o.order_date,
    o.amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;
-- OUTPUT
-- 1	Alice	201	2024-12-10	300
-- 1	Alice	202	2024-12-15	150
-- 1	Alice	211	2025-03-01	500
-- 2	Bob	203	2025-01-05	450
-- 2	Bob	204	2025-01-20	200
-- 2	Bob	213	2025-03-10	135
-- 3	Charlie	205	2025-01-25	125.5
-- 3	Charlie	206	2025-02-01	320.75
-- 3	Charlie	214	2025-03-15	160
-- 4	David	207	2025-02-10	210
-- 5	Eva	208	2025-02-15	180.25
-- 6	Frank	209	2025-02-20	400
-- 7	Grace	210	2025-02-25	275
-- 8	Hank	212	2025-03-05	220
-- 9	Ivy			
-- 10	John			
