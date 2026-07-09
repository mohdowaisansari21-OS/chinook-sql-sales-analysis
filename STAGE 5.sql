USE Chinook;

SELECT Name,UnitPrice,
RANK()
OVER(
ORDER BY UnitPrice
DESC
) AS Track_Ranks
FROM Track;

SELECT GenreId,Name,MilliSeconds,UnitPrice,
 DENSE_RANK()
OVER(
PARTITION BY GenreId
ORDER BY MilliSeconds
DESC
) AS Rank_By_Genre
FROM Track;

SELECT GenreId,MilliSeconds,
COUNT(*) AS Track_With_Same_Length
FROM Track
GROUP BY GenreId,MilliSeconds
HAVING COUNT(*)>1
ORDER BY Track_With_Same_Length
DESC;

SELECT Name, Milliseconds,
RANK() OVER (ORDER BY Milliseconds DESC) AS Rank_Version,
DENSE_RANK() OVER (ORDER BY Milliseconds DESC) AS Dense_Rank_Version
FROM Track
WHERE GenreId = 1
ORDER BY Milliseconds DESC;

SELECT InvoiceDate,Total,
SUM(Total)
OVER(
ORDER BY InvoiceDate
DESC
) AS Total_Invoice_Amounts
FROM Invoice;

SELECT InvoiceDate,Total,
SUM(Total)
OVER (
ORDER BY InvoiceDate
ASC
) AS TOtal_Invoice_Amounts
FROM Invoice;

SELECT CustomerId,InvoiceDate,Total,
LAG(Total)
OVER(
PARTITION BY CustomerId
ORDER BY InvoiceDate
ASC
) AS Total_Comparison
FROM Invoice;

SELECT*FROM(
SELECT CustomerId,InvoiceDate,Total,
ROW_NUMBER()
OVER(
PARTITION BY CustomerId
ORDER BY InvoiceDate
DESC
) AS Rank_By_Invoicedate
FROM Invoice
) AS Rank_by_Date
WHERE Rank_By_Invoicedate=1;
