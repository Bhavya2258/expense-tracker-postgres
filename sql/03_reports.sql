-- Total spending per month
SELECT
    DATE_TRUNC('month', t.transaction_date)::date AS month,
    SUM(t.amount) AS total_spent
FROM transactions t
JOIN categories c USING (category_id)
WHERE c.kind = 'expense'
GROUP BY 1
ORDER BY 1;

-- Spending per category per month
SELECT
    DATE_TRUNC('month', t.transaction_date)::date AS month,
    c.name AS category,
    SUM(t.amount) AS total_spent,
    COUNT(*) AS num_transactions
FROM transactions t
JOIN categories c USING (category_id)
WHERE c.kind = 'expense'
GROUP BY 1, 2
ORDER BY 1, total_spent DESC;

-- Income vs. expenses per month
SELECT
    DATE_TRUNC('month', t.transaction_date)::date AS month,
    SUM(t.amount) FILTER (WHERE c.kind = 'income')  AS income,
    SUM(t.amount) FILTER (WHERE c.kind = 'expense') AS expenses,
    SUM(t.amount) FILTER (WHERE c.kind = 'income')
      - SUM(t.amount) FILTER (WHERE c.kind = 'expense') AS net
FROM transactions t
JOIN categories c USING (category_id)
GROUP BY 1
ORDER BY 1;

-- Spending per account per month
SELECT
    DATE_TRUNC('month', t.transaction_date)::date AS month,
    a.name AS account,
    SUM(t.amount) AS total_spent
FROM transactions t
JOIN accounts a USING (account_id)
JOIN categories c USING (category_id)
WHERE c.kind = 'expense'
GROUP BY 1, 2
ORDER BY 1, 2;
