
/*-----
1. Write a SELECT statement that returns one row for each category that has products with these columns: 
The CategoryName column from the Categories table 
The count of the products in the Products table 
The list price of the most expensive product in the Products table 
Sort the result set so the category with the most products appears first. 
---*/

USE MyGuitarShop
GO


SELECT c.CategoryName, COUNT(p.ProductID) AS NumberOfProducts, MAX(p.ListPrice) AS MostExpensive
FROM Categories c Join Products p
ON c.CategoryID = p.CategoryID
GROUP BY C.CategoryName
ORDER BY NumberOfProducts
DESC;

 /*---------------------------------------------------------------------------------------------
2. Write a SELECT statement that returns one row for each customer that has orders with these columns: 
The EmailAddress column from the Customers table 
A count of the number of orders 
The total amount for those orders (Hint: First, subtract the discount amount from the price. Then, 
multiply by the quantity.)
------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO


SELECT c.EmailAddress, COUNT(o.OrderID) AS NumOfOrders, SUM(o.ItemPrice-o.DiscountAmount)*COUNT(o.orderID) AS TotalAmount

FROM Customers c 
	JOIN Orders ord
	ON c.CustomerID = ord.CustomerID
	JOIN OrderItems o 
	ON ord.OrderID = o.OrderID
GROUP BY c.EmailAddress;

 /*---------------------------------------------------------------------------------------------
3. Return only those rows where the customer has more than 1 order and so it only counts and totals line items 
that have an ItemPrice value that’s greater than 400. 
------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO


SELECT c.EmailAddress, COUNT(o.OrderID) AS NumOfOrders, SUM(o.ItemPrice-o.DiscountAmount)*COUNT(o.orderID) AS TotalAmount

FROM Customers c 
	JOIN Orders ord
	ON c.CustomerID = ord.CustomerID
	JOIN OrderItems o 
	ON ord.OrderID = o.OrderID
WHERE o.ItemPrice > 400
GROUP BY c.EmailAddress
HAVING COUNT(o.OrderID) > 1
ORDER BY TotalAmount
DESC;

 /*---------------------------------------------------------------------------------------------
4. Write a SELECT statement that returns the same result set as this SELECT statement, but don’t use a join. 
Instead, use a subquery in a WHERE clause that uses the IN keyword.

SELECT DISTINCT CategoryName 
FROM Categories c JOIN Products p 
 ON c.CategoryID = p.CategoryID 
ORDER BY CategoryName
------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO

SELECT DISTINCT CategoryName
FROM Categories
WHERE CategoryID In (
	SELECT CategoryID
	FROM Products)
ORDER BY CategoryName;

 /*---------------------------------------------------------------------------------------------
5. Write a SELECT statement that answers this question: Which products have a list price that’s greater than the 
average list price for all products? 
Return the ProductName and ListPrice columns for each product. 
Sort the results by the ListPrice column in descending sequence.
------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO

SELECT ProductName, ListPrice
FROM Products
WHERE ListPrice > (
	SELECT AVG(ListPrice)
	FROM Products)
Order BY ListPrice
DESC;


 /*---------------------------------------------------------------------------------------------
6. Write a SELECT statement that returns the CategoryName column from the Categories table. 
Return one row for each category that has never been assigned to any product in the Products table. To do 
that, use a subquery introduced with the NOT EXISTS operator.
------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO

SELECT CategoryName
FROM Categories c
WHERE NOT EXISTS(
	SELECT *
	FROM Products p
	WHERE p.CategoryID = c.CategoryID);


/*---------------------------------------------------------------------------------------------
7. Write a SELECT statement that returns the name and discount percent of each product that has a unique 
discount percent. In other words, don’t include products that have the same discount percent as another 
product. 
Sort the results by the ProductName column. 
------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO


SELECT ProductName, DiscountPercent
FROM Products p
WHERE DiscountPercent NOT IN (
	SELECT DISTINCT DiscountPercent
	FROM Products
	WHERE ProductID != p.ProductID)
ORDER BY ProductName
DESC;