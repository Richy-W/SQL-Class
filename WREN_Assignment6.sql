/*---------------------------------------------------------------------------------------------------------------
1. Write a script that creates and calls a function named fnDiscountPrice that calculates the discount 
price of an item in the OrderItems table (discount amount subtracted from item price). To do that, this 
function should accept one parameter for the item ID, and it should return the value of the discount 
price for that item.
2. Write a script that creates and calls a function named fnItemTotal that calculates the total amount of 
an item in the OrderItems table (discount price multiplied by quantity). To do that, this function 
should accept one parameter for the item ID, it should use the DiscountPrice function that you created 
in Question 1, and it should return the value of the total for that item.
3. Write a script that creates and calls a stored procedure named spInsertProduct that inserts a row into 
the Products table. This stored procedure should accept five parameters. One parameter for each of 
these columns: CategoryID, ProductCode, ProductName, ListPrice, and DiscountPercent.
This stored procedure should set the Description column to an empty string, and it should set the 
DateAdded column to the current date.
If the value for the ListPrice column is a negative number, the stored procedure should raise an error 
that indicates that this column doesn�t accept negative numbers. Similarly, the procedure should raise 
an error if the value for the DiscountPercent column is a negative number.
Code at least two EXEC statements that test this procedure.
4. Create a trigger named Products_UPDATE that checks the new value for the DiscountPercent column
of the Products table. This trigger should raise an appropriate error if the discount percent is greater 
than 100 or less than 0.
If the new discount percent is between 0 and 1, this trigger should modify the new discount percent 
by multiplying it by 100. That way, a discount percent of .2 becomes 20.
Test this trigger with an appropriate UPDATE statement.
5. Create a table named ProductsAudit. This table should have all columns of the Products table, except 
the Description column. Also, it should have an AuditID column for its primary key, and the 
DateAdded column should be changed to DateUpdated.
Create a trigger named Products_UPDATE. This trigger should insert the old data about the product 
into the ProductsAudit table after the row is updated. Then, test this trigger with an appropriate 
UPDATE statement
ON Products
AFTER UPDATE
AS
    INSERT INTO ProductsAudit
	(AuditID, ProductID, CategoryID, ProductCode, ProductName, ListPrice, DiscountPercent, DateUpdated)
	
		SELECT ProductID, CategoryID, ProductCode, ProductName, ListPrice, DiscountPercent, DateAdded
		FROM UPDATED;

/*------------------------------Note for Professor Mathew---------

I seemed to struggle with this assignment quite a bit. Do you have any other resources; maybe videos that can help me understand this better?

--------------------------------------*/