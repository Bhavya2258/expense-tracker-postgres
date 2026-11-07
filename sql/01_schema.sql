CREATE TABLE accounts (
    account_id  SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    type        TEXT NOT NULL CHECK (type IN ('checking', 'savings', 'credit_card', 'cash')),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    kind        TEXT NOT NULL CHECK (kind IN ('expense', 'income'))
);

CREATE TABLE transactions (
    transaction_id   BIGSERIAL PRIMARY KEY,
    account_id       INT NOT NULL REFERENCES accounts(account_id),
    category_id      INT NOT NULL REFERENCES categories(category_id),
    amount           NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    description      TEXT,
    transaction_date DATE NOT NULL,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_transactions_date ON transactions (transaction_date);
CREATE INDEX idx_transactions_category ON transactions (category_id);

CREATE VIEW monthly_category_spending AS
SELECT
    DATE_TRUNC('month', t.transaction_date)::date AS month,
    c.name AS category,
    SUM(t.amount) AS total_spent
FROM transactions t
JOIN categories c USING (category_id)
WHERE c.kind = 'expense'
GROUP BY 1, 2;