# Personal Expense Tracker (PostgreSQL)

A relational database for tracking personal income and expenses, with SQL
reports for monthly spending analysis. Built with PostgreSQL 16 and Docker.

## Schema

- **accounts**: checking, savings, credit card, cash
- **categories**: expense and income categories
- **transactions**: every transaction, linked to an account and a category

```
accounts (1) ──< transactions >── (1) categories
```

## Setup

1. Start Postgres with Docker:
   ```bash
   docker run --name expense-db -e POSTGRES_PASSWORD=secret -p 5432:5432 -d postgres:16
   docker exec -it expense-db psql -U postgres -c "CREATE DATABASE expense_tracker;"
   ```
2. Load the schema and seed data (run the seed file only once):
   ```bash
   docker exec -i expense-db psql -U postgres -d expense_tracker < sql/01_schema.sql
   docker exec -i expense-db psql -U postgres -d expense_tracker < sql/02_seed.sql
   ```
3. Run the reports in `sql/03_reports.sql` from VS Code (SQLTools) or `psql`.

## Sample reports

### Total spending per month

Uses `DATE_TRUNC` and `GROUP BY` to bucket expenses by month.

![Total spending per month](docs/Total%20spending%20per%20month.png)

> The most recent month is partial, since it only includes days up to the seed date.

### Spending per category per month

Breaks monthly spending down by category with `SUM` and `COUNT`.

![Spending per category per month](docs/Spending%20per%20category%20per%20month.png)

### Spending per account per month

Joins `transactions`, `accounts`, and `categories` to compare spending across accounts.

![Spending per account per month](docs/Spending%20per%20account%20per%20month.png)

### Income vs. expenses per month

Uses `FILTER` to compute income, expenses, and net savings in a single query.

![Income vs. expenses per month](docs/Income%20vs.%20expenses%20per%20month.png)

## Design decisions

- `NUMERIC(12,2)` for money to avoid floating-point rounding errors
- Amounts are always positive; the category's `kind` says whether it is income or an expense
- Foreign keys and `CHECK` constraints keep invalid data out
- Indexes on `transaction_date` and `category_id` to speed up reports
- A view (`monthly_category_spending`) for reusable reporting

## Project structure

```
Expense_Tracker/
├── README.md
├── docs/        (report screenshots)
└── sql/
    ├── 01_schema.sql
    ├── 02_seed.sql
    └── 03_reports.sql
```

## Skills demonstrated

Schema design, joins, aggregation, `DATE_TRUNC`, `FILTER`, CTEs, views,
indexing, Docker