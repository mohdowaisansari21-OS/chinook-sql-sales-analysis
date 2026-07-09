-- =====================================================================
-- Tracks Priced Above Their Own Genre's Average
-- Question: Does pricing vary within a genre, and are any tracks
--           priced above their genre's average?
-- Technique: Correlated subquery (inner query re-evaluates per outer row,
--            comparing each track's GenreId to the current row's GenreId)
-- =====================================================================

USE Chinook;

SELECT T1.Name, T1.UnitPrice, G.Name AS Genre
FROM Track AS T1
INNER JOIN Genre AS G
    ON T1.GenreId = G.GenreId
WHERE T1.UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM Track AS T2
    WHERE T2.GenreId = T1.GenreId
);

-- Result: 0 rows.

-- Diagnostic query used to confirm this was a genuine data property,
-- not a broken query:
SELECT GenreId, MIN(UnitPrice) AS Min_Price, MAX(UnitPrice) AS Max_Price,
       COUNT(DISTINCT UnitPrice) AS Distinct_Prices
FROM Track
GROUP BY GenreId;

-- Finding: every genre has exactly ONE price for all its tracks
-- (Distinct_Prices = 1 for all 25 genres). Pricing in this dataset is
-- driven by media TYPE (audio vs. video), not by genre — so a
-- genre-based pricing strategy would need catalog restructuring to
-- be meaningful here. A real, useful finding despite the zero-row result.
