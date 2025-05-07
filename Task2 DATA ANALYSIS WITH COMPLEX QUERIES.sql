-- 1. Total Order Amount Per Customer (Using GROUP BY)
SELECT 
    c.name,
    SUM(o.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;
-- OUTPUT
-- Alice	950
-- Bob	785
-- Charlie	606.25
-- Frank	400
-- Grace	275
-- Hank	220
-- David	210
-- Eva	180.25

-- 2. Running Total of Orders per Customer using WINDOW FUNCTION
SELECT 
    c.name,
    o.order_id,
    o.order_date,
    o.amount,
    SUM(o.amount) OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS running_total
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;
-- OUTPUT
-- Alice	201	2024-12-10	300	300
-- Alice	202	2024-12-15	150	450
-- Alice	211	2025-03-01	500	950
-- Bob	203	2025-01-05	450	450
-- Bob	204	2025-01-20	200	650
-- Bob	213	2025-03-10	135	785
-- Charlie	205	2025-01-25	125.5	125.5
-- Charlie	206	2025-02-01	320.75	446.25
-- Charlie	214	2025-03-15	160	606.25
-- David	207	2025-02-10	210	210
-- Eva	208	2025-02-15	180.25	180.25
-- Frank	209	2025-02-20	400	400
-- Grace	210	2025-02-25	275	275
-- Hank	212	2025-03-05	220	220

-- 3. Rank Customers by Total Amount Spent
SELECT 
    name,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS rank_by_spending
FROM (
    SELECT 
        c.name,
        SUM(o.amount) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.name
) AS ranked;
-- OUTPUT
-- Alice	950	1
-- Bob	785	2
-- Charlie	606.25	3
-- Frank	400	4
-- Grace	275	5
-- Hank	220	6
-- David	210	7
-- Eva	180.25	8

-- 4. Get Top 2 Latest Orders Per Customer (ROW_NUMBER)
SELECT *
FROM (
    SELECT 
        c.name,
        o.order_id,
        o.order_date,
        o.amount,
        ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.order_date DESC) AS rn
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
) AS temp
WHERE rn <= 2;
-- OUTPUT
-- Bob	204	2025-01-20	200	2
-- Charlie	214	2025-03-15	160	1
-- Charlie	206	2025-02-01	320.75	2
-- David	207	2025-02-10	210	1
-- Eva	208	2025-02-15	180.25	1
-- Frank	209	2025-02-20	400	1
-- Grace	210	2025-02-25	275	1
-- Hank	212	2025-03-05	220	1

-- 5. Use CTE to get average spend per customer and filter high spenders
WITH customer_totals AS (
    SELECT 
        c.customer_id,
        c.name,
        SUM(o.amount) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.name
)
SELECT * 
FROM customer_totals
WHERE total_spent > 500;
-- OUTPUT
-- 1	Alice	950
-- 2	Bob	785
-- 3	Charlie	606.25

-- 6. Orders above average amount (using subquery)
SELECT 
    o.order_id,
    o.amount,
    o.order_date
FROM orders o
WHERE amount > (SELECT AVG(amount) FROM orders);
-- OUTPUT
-- 201	300	2024-12-10
-- 203	450	2025-01-05
-- 206	320.75	2025-02-01
-- 209	400	2025-02-20
-- 210	275	2025-02-25
-- 211	500	2025-03-01
-- 215	300	2025-03-20
