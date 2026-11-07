INSERT INTO accounts (name, type) VALUES
    ('Main Checking', 'checking'),
    ('Savings', 'savings'),
    ('Credit Card', 'credit_card');

INSERT INTO categories (name, kind) VALUES
    ('Groceries', 'expense'),
    ('Rent', 'expense'),
    ('Dining Out', 'expense'),
    ('Transport', 'expense'),
    ('Entertainment', 'expense'),
    ('Utilities', 'expense'),
    ('Salary', 'income');

INSERT INTO transactions (account_id, category_id, amount, description, transaction_date)
SELECT
    1 + floor(random() * 3)::int,
    1 + floor(random() * 6)::int,
    round((random() * 100 + 5)::numeric, 2),
    'Seeded expense',
    CURRENT_DATE - (random() * 365)::int
FROM generate_series(1, 500);

INSERT INTO transactions (account_id, category_id, amount, description, transaction_date)
SELECT 1, 7, 3000.00, 'Monthly salary',
       (date_trunc('month', CURRENT_DATE) - (n || ' months')::interval)::date
FROM generate_series(0, 11) AS n;