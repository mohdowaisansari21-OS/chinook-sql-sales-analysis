# chinook-sql-sales-analysis
SQL analysis of music store sales using Chinook database
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 🎵 Chinook Music Store — Sales & Customer Analysis (SQL)

Analysis of a digital music store's sales data to uncover revenue drivers, high-value customers, and pricing patterns — using SQL joins, subqueries, CTEs, and window functions.

## 📌 Objective

Digital music/media stores need to know **where their revenue comes from** and **who their most valuable customers are** in order to prioritize marketing, licensing, and retention efforts. This project uses SQL to answer that from raw transactional data — customers, invoices, and a track/album/artist/genre catalog.

## 🗂️ Dataset

- Source: Chinook sample database (digital music store) — https://github.com/lerocha/chinook-database
- Format: MySQL
- Tables used: Customer, Invoice, InvoiceLine, Track, Album, Artist, Genre
- Size: ~59 customers, ~412 invoices, ~3500 tracks

**To reproduce:** import `dataset/Chinook_MySql.sql` into MySQL Workbench 
(or any MySQL client) to recreate the database used in this project.

## ❓ Key Questions Answered

1. Which countries generate the most revenue, and where should sales focus expand?
2. Who are the highest-spending customers, and how concentrated is revenue among them?
3. Are there customers who have never made a purchase (retention/onboarding risk)?
4. How does cumulative revenue trend over time?
5. Which tracks are priced above their own genre's average — and does pricing actually vary by genre?
6. What is each customer's most recent purchase, for re-engagement targeting?

## 🛠️ Techniques & Tools

- **Tool:** MySQL Workbench
- **SQL techniques:** multi-table `JOIN`s (chained across 3+ tables), `LEFT JOIN` for gap analysis, `GROUP BY` / `HAVING`, `CASE WHEN` segmentation, scalar & correlated subqueries, derived tables, `CTE`s (`WITH`), window functions (`RANK`, `DENSE_RANK`, `SUM() OVER`, `LAG`, `ROW_NUMBER`)

## 📊 Key Findings

- **Revenue is broadly spread, not concentrated in one market** — the USA, Canada, France, Brazil, and Germany form the top 5 countries by revenue, suggesting a genuinely international customer base rather than reliance on a single region.
- **No customers with zero purchases** — a `LEFT JOIN` + `IS NULL` check confirmed every customer in the dataset has made at least one purchase, meaning churn/reactivation efforts should focus on *recency* of purchase rather than customer acquisition follow-through.
- **Top spender contributes disproportionately** — the highest-spending customer (Helena Holý) accounts for **$49.62** in lifetime spend, identified via a nested aggregate query comparing each customer's total against the dataset-wide maximum — a useful pattern for flagging VIP customers at scale.
- **Pricing is driven by media format, not genre** — a correlated subquery testing "tracks priced above their own genre's average" returned zero results; a follow-up diagnostic confirmed every genre has uniform pricing internally (price varies by media type — audio vs. video — not by genre). A real finding in itself: genre-based pricing strategies wouldn't apply here without restructuring the catalog.
- **Revenue accumulates steadily rather than in sharp spikes**, based on a running-total analysis ordered chronologically — useful for baseline forecasting.

## 📁 Files

- `queries/revenue_by_country.sql` — total revenue and ranking by billing country
- `queries/customer_ltv_top_spender.sql` — nested subquery identifying the highest lifetime-value customer
- `queries/churn_check_left_join.sql` — LEFT JOIN + IS NULL pattern to find customers with no purchases
- `queries/genre_pricing_correlated_subquery.sql` — correlated subquery + diagnostic on genre-level pricing
- `queries/running_total_revenue.sql` — cumulative revenue over time using SUM() OVER
- `queries/most_recent_invoice_per_customer.sql` — ROW_NUMBER() + PARTITION BY for latest purchase per customer
- `queries/rank_vs_dense_rank_by_genre.sql` — RANK() vs DENSE_RANK() tie-handling, verified on real data
- `queries/practice_history/` — full progression of SQL practice from fundamentals through window functions (Stages 1–5), included for anyone who wants to see the learning process, not just the final output

## 🔍 Sample Queries

**Top 5 countries by revenue:**
```sql
SELECT BillingCountry, SUM(Total) AS Total_Revenue
FROM Invoice
GROUP BY BillingCountry
ORDER BY Total_Revenue DESC
LIMIT 5;
```

**Highest lifetime-value customer (nested aggregate):**
```sql
SELECT C.CustomerId, C.FirstName, C.LastName, SUM(I.Total) AS Total_Spent
FROM Customer AS C
INNER JOIN Invoice AS I ON C.CustomerId = I.CustomerId
GROUP BY C.CustomerId
HAVING SUM(I.Total) = (
    SELECT MAX(Total_Spent) FROM (
        SELECT SUM(I.Total) AS Total_Spent
        FROM Customer AS C
        INNER JOIN Invoice AS I ON C.CustomerId = I.CustomerId
        GROUP BY C.CustomerId
    ) AS Customer_Totals
);
```

**Each customer's most recent invoice (window function):**
```sql
SELECT * FROM (
    SELECT CustomerId, InvoiceDate, Total,
    ROW_NUMBER() OVER (
        PARTITION BY CustomerId
        ORDER BY InvoiceDate DESC
    ) AS rn
    FROM Invoice
) AS Ranked
WHERE rn = 1;
```

## 💡 What I Learned

This project moved beyond writing individual queries to combining techniques — joins feeding into subqueries, subqueries feeding into window functions — to answer layered business questions. It also reinforced a habit worth calling out: verifying unexpected results (e.g. zero rows, uniform ties) against the underlying data with a diagnostic query before assuming a query is broken, rather than guessing.

---
*Built while working through a structured SQL learning path : 
fundamentals → aggregation → joins → subqueries/CTEs → window functions) on the Chinook database.*
