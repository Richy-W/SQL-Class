/*---------------------------------------------------------------------------------------------------------------------
1. Create a view named CustomerAddresses that shows the shipping and billing addresses for each 
customer in the MyGuitarShop database. 
This view should return these columns from the Customers table: CustomerID, EmailAddress, 
LastName and FirstName. 
This view should return these columns from the Addresses table: BillLine1, BillLine2, BillCity, 
BillState, BillZip, ShipLine1, ShipLine2, ShipCity, ShipState, and ShipZip. 
Use the BillingAddressID and ShippingAddressID columns in the Customers table to determine 
which addresses are billing addresses and which are shipping addresses. 
Hint: You can use two JOIN clauses to join the Addresses table to Customers table twice (once for 
each type of address)
---------------------------------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO

Create VIEW CustomerAddresses
AS
SELECT c.CustomerID, c.EmailAddress, c.LastName, c.FirstName,
	ba.Line1 AS BillLine1, ba.Line2 AS BillLine2, ba.City AS BillCity, ba.State AS BillState, ba.ZipCode AS BillZip,
	sa.Line1 AS ShipLine1, sa.Line2 AS ShipLine2, sa.City AS ShipCity, sa.State AS ShipState, sa.ZipCode AS ShipZip
FROM Customers c JOIN Addresses ba
ON c.BillingAddressID = ba.AddressID JOIN Addresses sa
ON c.ShippingAddressID = sa.AddressID;



/*---------------------------------------------------------------------------------------------------------------------
2. Write a SELECT statement that returns these columns from the CustomerAddresses view that you 
created in exercise 1: CustomerID, LastName, FirstName, BillLine1. 
---------------------------------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO

SELECT CustomerID, LastName, FirstName, BillLine1
FROM CustomerAddresses;


/*---------------------------------------------------------------------------------------------------------------------
3. Write an UPDATE statement that updates the CustomerAddresses view you created in exercise 1 so it 
sets the first line of the shipping address to “1990 Westwood Blvd.” for the customer with an ID of 8.
---------------------------------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO

UPDATE CustomerAddresses
SET ShipLine1 = '1990 Westwood Blvd.'
WHERE CustomerID = 8;



/*---------------------------------------------------------------------------------------------------------------------
4. Create a view named OrderItemProducts that returns columns from the Orders, OrderItems, and 
Products tables. 
This view should return these columns from the Orders table: OrderID, OrderDate, TaxAmount, and 
ShipDate. 
This view should return these columns from the OrderItems table: ItemPrice, DiscountAmount, 
FinalPrice (the discount amount subtracted from the item price), Quantity, and ItemTotal (the 
calculated total for the item). 
This view should return the ProductName column from the Products table. 
---------------------------------------------------------------------------------------------------------------------*/

USE MyGuitarShop
GO

CREATE VIEW OrderItemProducts
AS

SELECT o.OrderID, o.OrderDate, o.TaxAmount, o.ShipDate, oi.ItemPrice, 
	oi.DiscountAmount, (oi.ItemPrice - oi.DiscountAmount) AS FinalPrice, oi.Quantity, (oi.ItemPrice - oi.DiscountAmount) * oi.Quantity AS ItemTotal,
	p.ProductName
FROM Orders o JOIN OrderItems oi
ON o.OrderID = oi.OrderID JOIN Products p
ON oi.ProductID = p.ProductID;


/*---------------------------------------------------------------------------------------------------------------------
5. Create a view named ProductSummary that uses the view you created in exercise 4. This view should 
return some summary information about each product. 
Each row should include these columns: ProductName, OrderCount (the number of times the product 
has been ordered), and OrderTotal (the total sales for the product). 
Write a SELECT statement that uses the view that you created to get total sales for the five best 
selling products.
---------------------------------------------------------------------------------------------------------------------*/

CREATE VIEW ProductSummary
AS
SELECT ProductName, SUM(Quantity) AS OrderCount, SUM(ItemTotal) AS OrderTotal
FROM OrderItemProducts
GROUP BY ProductName; 

--SELECT statement--

SELECT SUM(OrderTotal) AS TopFiveTotal
FROM 
		(SELECT TOP 5 OrderTotal
		FROM ProductSummary
		ORDER BY OrderCount DESC) sub;
