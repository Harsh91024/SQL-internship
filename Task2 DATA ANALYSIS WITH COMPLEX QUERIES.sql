-- 1. Total Order Amount Per Customer (Using GROUP BY)
SELECT 
    c.name,
    SUM(o.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;

-- 2. Running Total of Orders per Customer using WINDOW FUNCTION
SELECT 
    c.name,
    o.order_id,
    o.order_date,
    o.amount,
    SUM(o.amount) OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS running_total
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

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

-- 6. Orders above average amount (using subquery)
SELECT 
    o.order_id,
    o.amount,
    o.order_date
FROM orders o
WHERE amount > (SELECT AVG(amount) FROM orders);