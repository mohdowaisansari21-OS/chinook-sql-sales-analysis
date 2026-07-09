-- =====================================================================
-- Track Ranking Within Genre (RANK vs DENSE_RANK)
-- Question: How do tracks rank by length within their own genre, and
--           how should ties be handled?
-- Technique: PARTITION BY + ORDER BY, comparing RANK() and DENSE_RANK()
--            side by side on the same tie.
-- =====================================================================

USE Chinook;

-- Overall ranking of all tracks by price, highest first
SELECT Name, UnitPrice,
RANK() OVER (
    ORDER BY UnitPrice DESC
) AS Track_Rank
FROM Track;

-- Rank tracks by length (Milliseconds) within each genre
SELECT GenreId, Name, Milliseconds, UnitPrice,
DENSE_RANK() OVER (
    PARTITION BY GenreId
    ORDER BY Milliseconds DESC
) AS Rank_By_Genre
FROM Track;

-- Diagnostic: find genres/durations where multiple tracks tie exactly,
-- to demonstrate RANK() vs DENSE_RANK() tie-handling on real data
SELECT GenreId, Milliseconds, COUNT(*) AS Tracks_With_Same_Length
FROM Track
GROUP BY GenreId, Milliseconds
HAVING COUNT(*) > 1
ORDER BY Tracks_With_Same_Length DESC;

-- Side-by-side comparison on a confirmed tie (GenreId = 1)
SELECT Name, Milliseconds,
RANK() OVER (ORDER BY Milliseconds DESC) AS Rank_Version,
DENSE_RANK() OVER (ORDER BY Milliseconds DESC) AS Dense_Rank_Version
FROM Track
WHERE GenreId = 1
ORDER BY Milliseconds DESC;

-- Finding: 3 tracks tie at 210259ms with Rank_Version = 1002 and
-- Dense_Rank_Version = 946. The next distinct value (209789ms) becomes
-- Rank_Version = 1005 (skips 3 positions for the 3 tied rows) vs.
-- Dense_Rank_Version = 947 (no skip). RANK() is the right choice when
-- "how many rows outrank this one" matters (e.g. competition standings);
-- DENSE_RANK() is right when only "how many distinct tiers exist" matters
-- (e.g. pricing tiers, rating buckets).
