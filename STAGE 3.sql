USE Chinook;
SELECT Customer.Firstname,Customer.Lastname,Invoice.InvoiceID,Invoice.InvoiceDate,Invoice.Total
FROM Customer
INNER JOIN Invoice
ON Customer.CustomerID=Invoice.CustomerID;

SELECT Track.Name, Album.Title
FROM Track
INNER JOIN Album
ON Track.AlbumId = Album.AlbumId;

SELECT Track.Name,Genre.Name
FROM Track
INNER JOIN Genre
ON Track.GenreId=Genre.GenreId;

SELECT Track.Name,Album.Title,Artist.Name
FROM Track
INNER JOIN Album
ON Track.AlbumId=Album.AlbumId
INNER JOIN Artist
ON Album.ArtistId=Artist.ArtistId;

SELECT C.FirstName,C.LastName,I.InvoiceId,I.InvoiceDate,I.Total
FROM Customer AS C
LEFT JOIN Invoice AS I
ON C.CustomerId=I.CustomerId;

SELECT C.FirstName,C.LastName,I.InvoiceId,InvoiceDate,I.Total
FROM Customer AS c
LEFT JOIN Invoice AS I
ON C.CustomerId=I.CustomerId
WHERE I.InvoiceId IS NULL;

SELECT C.Firstname,C.LastName,SUM(I.Total) AS Total_Spent
FROM Customer AS C
INNER JOIN Invoice AS I
ON C.CustomerId=I.CustomerId
GROUP BY C.CustomerId;

