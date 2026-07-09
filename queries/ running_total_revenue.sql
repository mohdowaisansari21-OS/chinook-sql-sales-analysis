-- =====================================================================
-- Running Total of Revenue Over Time
-- Question: How does cumulative revenue build up over time?
-- Technique: Window function — SUM() OVER (ORDER BY ...)
-- =====================================================================

USE Chinook;

SELECT InvoiceDate, Total,
SUM(Total) OVER (
    ORDER BY InvoiceDate ASC
) AS Running_Total
FROM Invoice;

-- ASC ordering accumulates forward chronologically (the earliest invoice
-- first), matching the conventional business meaning of a "running total."
-- Finding: revenue accumulates steadily over the period covered, without
-- sharp spikes or drop-offs — useful as a baseline for simple forecasting.
