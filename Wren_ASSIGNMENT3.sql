
/*---------------------------------------------------------------------------------------------
1) Write a SELECT statement that returns four columns from the Products table: ProductCode, 
ProductName, ListPrice, and DiscountPercent. The result set should be sorted by list price in 
descending sequence. 
----------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO

SELECT [ListPrice], [ProductCode], [ProductName], [DiscountPercent]
FROM Products 
ORDER BY [ListPrice]
DESC;

/*-------------------------------------------------------------------------------------------------
2) Write a SELECT statement that returns these column names and data from the Products table:
ProductName The ProductName column
ListPrice The ListPrice column
DateAdded The DateAdded column
Return only the rows with a list price that’s greater than 500 and less than 2000. Sort the result set in 
descending sequence by the DateAdded column.
-------------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO

SELECT [ProductName], [ListPrice], [DateAdded]
FROM Products 
WHERE [ListPrice] BETWEEN 500 AND 2000
ORDER BY [ListPrice]
DESC;

/*------------------------------------------------------------------------------------------------
3) Write a SELECT statement that returns these columns from the Orders table:
OrderID The OrderID column
OrderDate The OrderDate column
ShipDate The ShipDate column
Return only the rows where the ShipDate column contains a null value.
------------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO

SELECT [OrderID], [OrderDate], [ShipDate]
FROM Orders
WHERE [ShipDate] IS NULL;

/*-------------------------------------------------------------------------------------------------
4)  Write a SELECT statement that joins the Customers table to the Addresses table and returns these 
columns: FirstName, LastName, Line1, City, State, ZipCode.
Return one row for each customer, but only return addresses that are the shipping address for a 
customer.
-------------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO


SELECT c.FirstName,c.LastName,a.Line1,a.City,a.State,a.ZipCode
FROM Customers c JOIN Addresses a on c.CustomerID = a.CustomerID
WHERE a.AddressID = c.ShippingAddressID;


/*----------------------------------------------------------------------------------------------
5) Write a SELECT statement that returns the ProductName and ListPrice columns from the Products 
table. Return one row for each product that has the same list price as another product. Sort the result 
set by ProductName.
(Hint: Use a self-join to check that the ProductID columns aren’t equal but the ListPrice column is 
equal.)
-----------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO


SELECT p.ProductName, p.ListPrice
FROM Products p JOIN Products l ON p.ProductID != l.ProductID
AND p.ListPrice = l.ListPrice
ORDER BY p.ProductName
ASC;


/*------------------------------------------------------------------------------------------------
6) Write a SELECT statement that returns these two columns: 
CategoryName The CategoryName column from the Categories table
ProductID The ProductID column from the Products table
Return one row for each category that has never been used. (Hint: Use an outer join and only return 
rows where the ProductID column contains a null value.)
-------------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO


SELECT c.CategoryName, p.ProductID
FROM Categories c LEFT JOIN Products p ON c.CategoryID = p.CategoryID
WHERE p.ProductID IS NULL;


/*--------------------------------------------------------------------------------------------------
7)  Use the UNION operator to generate a result set consisting of three columns from the Orders table: 
ShipStatus A calculated column that contains a value of SHIPPED or NOT 
SHIPPED
OrderID The OrderID column
OrderDate The OrderDate column
If the order has a value in the ShipDate column, the ShipStatus column should contain a value of 
SHIPPED. Otherwise, it should contain a value of NOT SHIPPED.
Sort the result set by OrderDate.
--------------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO


SELECT 'SHIPPED' AS ShipDate, OrderID, OrderDate
FROM Orders
WHERE ShipDate IS NOT NULL

UNION

SELECT 'NOT SHIPPED' AS ShipDate, OrderID, OrderDate
FROM Orders
WHERE ShipDate IS NULL
ORDER BY OrderDate
ASC;