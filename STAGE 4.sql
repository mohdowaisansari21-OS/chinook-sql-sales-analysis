USE Chinook;
SELECT Name,UnitPrice
FROM Track
WHERE UnitPrice>(SELECT AVG(UnitPrice) FROM Track);

SELECT FirstName,LastName,CustomerId
FROM Customer
WHERE CustomerId IN(SELECT CustomerId FROM Invoice WHERE Total>15);

SELECT C.CustomerId,C.FirstName,C.LastName, SUM(I.Total) AS Total_Spent
FROM Customer AS C
INNER JOIN Invoice AS I
ON C.CustomerId=I.CustomerId
GROUP BY CustomerId HAVING SUM(I.Total)=
(SELECT MAX(Total_Spent) FROM (SELECT C.CustomerId,C.FirstName,C.LastName, SUM(I.Total) AS Total_Spent
FROM Customer AS C
INNER JOIN Invoice AS I
ON C.CustomerId=I.CustomerId
GROUP BY CustomerId) AS Customer_total);

SELECT T1.Name,T1.UnitPrice,G.Name
FROM TRACK AS T1
INNER JOIN Genre AS G
ON T1.GenreId=G.GenreId
WHERE UnitPrice>
(SELECT AVG(UnitPrice) FROM TRACK AS T2
WHERE T2.GenreId=T1.GenreId);

WITH Avg_Track_Price AS
(SELECT AVG(UnitPrice) AS Average_Price
FROM Track)
SELECT Name,UnitPrice
FROM Track
WHERE UnitPrice > (SELECT Average_Price FROM Avg_Track_Price);

WITH Total_Spending AS(
SELECT C.FirstName,C.LastName,SUM(I.Total) AS Total_Spent
FROM Customer AS C
INNER JOIN Invoice AS I
ON C.CustomerId=I.CustomerId
GROUP BY C.CustomerId
HAVING  Total_Spent>40)
SELECT FirstName,LastName,Total_Spent  FROM Total_Spending;




