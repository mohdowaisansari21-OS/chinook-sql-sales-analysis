-- =====================================================================
-- Customers With Zero Purchases (Churn / Onboarding Risk Check)
-- Question: Are there customers who signed up but never purchased?
-- Technique: LEFT JOIN + WHERE right_table.column IS NULL
--            (standard pattern for finding unmatched left-side rows)
-- =====================================================================

USE Chinook;

SELECT C.FirstName, C.LastName, I.InvoiceId, I.InvoiceDate, I.Total
FROM Customer AS C
LEFT JOIN Invoice AS I
    ON C.CustomerId = I.CustomerId
WHERE I.InvoiceId IS NULL;

-- Result: 0 rows.
-- Finding: every customer in this dataset has made at least one purchase.
-- In a real/live system, this query would flag zero-purchase customers
-- for onboarding follow-up; here it confirms retention efforts should
-- focus on RECENCY of purchase rather than acquisition follow-through
-- (see most_recent_invoice_per_customer.sql).
