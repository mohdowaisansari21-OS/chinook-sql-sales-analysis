-- =====================================================================
-- Revenue by Country
-- Question: Which countries generate the most revenue, and where
--           should sales/marketing focus expand?
-- =====================================================================

USE Chinook;

SELECT BillingCountry, SUM(Total) AS Total_Revenue
FROM Invoice
GROUP BY BillingCountry
ORDER BY Total_Revenue DESC
LIMIT 5;

-- Finding: Revenue is spread across several countries (USA, Canada,
-- France, Brazil, Germany lead) rather than concentrated in one market,
-- suggesting a genuinely international customer base.
