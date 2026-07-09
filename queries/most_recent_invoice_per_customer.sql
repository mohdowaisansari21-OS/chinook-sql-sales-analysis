-- =====================================================================
-- Each Customer's Most Recent Invoice
-- Question: What was each customer's most recent purchase, for
--           re-engagement / recency-based targeting?
-- Technique: ROW_NUMBER() + PARTITION BY, wrapped in a subquery so the
--            window function's output can be filtered (WHERE cannot
--            filter a window function's result directly in the same
--            query it's calculated in).
-- =====================================================================

USE Chinook;

SELECT * FROM (
    SELECT CustomerId, InvoiceDate, Total,
    ROW_NUMBER() OVER (
        PARTITION BY CustomerId
        ORDER BY InvoiceDate DESC
    ) AS Rank_By_InvoiceDate
    FROM Invoice
) AS Ranked_Invoices
WHERE Rank_By_InvoiceDate = 1;

-- Returns exactly one row per customer: their single most recent invoice.
-- PARTITION BY CustomerId keeps each customer's invoices independent;
-- ORDER BY InvoiceDate DESC ranks the latest invoice as 1 within each group.
