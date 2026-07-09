USE Chinook;
SELECT COUNT(CustomerID) AS Total_Customer From customer;
SELECT SUM(total) AS Total_Revenue FROM Invoice;
SELECT AVG(total) AS Average_Total FROM Invoice;
SELECT MAX(total) AS Highest_Invoice,MIN(total) AS Lowest_Invoice FROM invoice;
SELECT BillingCountry,SUM(total) AS Total_Revenue FROM  Invoice GROUP BY BillingCountry;
SELECT Country,COUNT(CustomerId) AS Total_Customer FROM Customer GROUP BY Country;
SELECT GenreID,AVG(UnitPrice) AS Average_Price From Track GROUP BY GenreId;
SELECT BillingCountry,SUM(total) AS Total_Revenue FROM invoice GROUP BY BillingCountry ORDER BY Total_Revenue DESC LIMIT 5 ;
SELECT BillingCountry,SUM(total) AS Total_Revenue FROM invoice GROUP BY BillingCountry Having Total_Revenue>50;
SELECT InvoiceID,Total,
CASE 
WHEN Total < 5 THEN 'LOW' 
WHEN Total BETWEEN 5 and 10 THEN 'MEDIUM'
WHEN Total >10 THEN 'HIGH'
ELSE '0'
END
AS Value_Label
FROM Invoice;