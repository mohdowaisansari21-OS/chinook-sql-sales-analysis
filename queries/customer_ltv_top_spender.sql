-- =====================================================================
-- Highest Lifetime-Value Customer
-- Question: Who is the highest-spending customer, and how can we
--           flag top-value customers like them at scale?
-- Technique: JOIN + GROUP BY + SUM, compared against a derived table
--            (nested subquery) that computes the MAX of all per-customer
--            totals.
-- =====================================================================

USE Chinook;

SELECT C.CustomerId, C.FirstName, C.LastName, SUM(I.Total) AS Total_Spent
FROM Customer AS C
INNER JOIN Invoice AS I
    ON C.CustomerId = I.CustomerId
GROUP BY C.CustomerId
HAVING SUM(I.Total) = (
    SELECT MAX(Total_Spent) FROM (
        SELECT C.CustomerId, C.FirstName, C.LastName, SUM(I.Total) AS Total_Spent
        FROM Customer AS C
        INNER JOIN Invoice AS I
            ON C.CustomerId = I.CustomerId
        GROUP BY C.CustomerId
    ) AS Customer_total
);

-- Result: CustomerId 6, Helena Holy — Total_Spent = 49.62
-- This is the single highest lifetime spend in the dataset.

-- Bonus: full list of all customers who spent more than $40
-- (a lighter-weight VIP threshold, using a CTE instead of a nested subquery)
WITH Total_Spending AS (
    SELECT C.FirstName, C.LastName, SUM(I.Total) AS Total_Spent
    FROM Customer AS C
    INNER JOIN Invoice AS I
        ON C.CustomerId = I.CustomerId
    GROUP BY C.CustomerId
    HAVING Total_Spent > 40
)
SELECT FirstName, LastName, Total_Spent
FROM Total_Spending;
