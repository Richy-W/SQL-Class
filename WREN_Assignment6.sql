/*---------------------------------------------------------------------------------------------------------------
1. Write a script that creates and calls a function named fnDiscountPrice that calculates the discount 
price of an item in the OrderItems table (discount amount subtracted from item price). To do that, this 
function should accept one parameter for the item ID, and it should return the value of the discount 
price for that item.-----------------------------------------------------------------------------------------------------------------*/CREATE FUNCTION dbo.fnDiscountPrice(@ItemID int)RETURNS MONEYASBEGIN	DECLARE @DiscountPrice MONEY	SELECT @DiscountPrice = ItemPrice -DiscountAmount	FROM OrderItems	WHERE ItemID = @ItemID	RETURN @DiscountPrice;ENDSELECT dbo.fnDiscountPrice(ItemID)FROM OrderItems/*---------------------------------------------------------------------------------------------------------------
2. Write a script that creates and calls a function named fnItemTotal that calculates the total amount of 
an item in the OrderItems table (discount price multiplied by quantity). To do that, this function 
should accept one parameter for the item ID, it should use the DiscountPrice function that you created 
in Question 1, and it should return the value of the total for that item.-----------------------------------------------------------------------------------------------------------------*/CREATE FUNCTION dbo.fnItemTotal(@ItemID INT)RETURNS MONEYASBEGINDECLARE @ItemTotal MONEY	SELECT @ItemTotal = Quantity * dbo.fnDiscountPrice(@ItemID)	FROM OrderItems	WHERE @ItemID = ItemID	RETURN @ItemTotal;ENDSELECT dbo.fnItemTotal(ItemID)FROM OrderItems/*---------------------------------------------------------------------------------------------------------------
3. Write a script that creates and calls a stored procedure named spInsertProduct that inserts a row into 
the Products table. This stored procedure should accept five parameters. One parameter for each of 
these columns: CategoryID, ProductCode, ProductName, ListPrice, and DiscountPercent.
This stored procedure should set the Description column to an empty string, and it should set the 
DateAdded column to the current date.
If the value for the ListPrice column is a negative number, the stored procedure should raise an error 
that indicates that this column doesn’t accept negative numbers. Similarly, the procedure should raise 
an error if the value for the DiscountPercent column is a negative number.
Code at least two EXEC statements that test this procedure.-----------------------------------------------------------------------------------------------------------------*/ CREATE PROC spInsertProduct	(		@CategoryID INT,		@ProductCode NVARCHAR(10),		@ProductName NVARCHAR (50),		@ListPrice MONEY,		@DiscountPercent DECIMAL (10,2)	)ASBEGIN TRY		----- validate list price	IF @ListPrice < 0		THROW 5065, 'Negative Numbers Not Allowed', 1; 		------Validate DiscountPercent	IF @DiscountPercent < 0		THROW 5065, 'Negative Numbers Not Allowed', 1;		INSERT Products		VALUES		(			[CategoryID] = @CategoryID,      -- I cant figure out why the CategoryID column is invalid?			[ProductCode] = @ProductCode,			[ProductName] = @ProductName,			[ListPrice] = @ListPrice,			[DiscountPercent] = @DiscountPercent,			[Description] = ' '			[DateAdded] = GETDATE()		);END TRYBEGIN CATCH	THROW;END CATCHSELECT* FROM PRODUCTS---TESTSEXEC spInsertProduct (1, 'test1', 'Test Product Name', 150, 50);EXEC spInsertProduct (1, 'test1', 'Test Product Name', 150, -50);EXEC spInsertProduct (1, 'test1', 'Test Product Name', -150, 50);/*---------------------------------------------------------------------------------------------------------------
4. Create a trigger named Products_UPDATE that checks the new value for the DiscountPercent column
of the Products table. This trigger should raise an appropriate error if the discount percent is greater 
than 100 or less than 0.
If the new discount percent is between 0 and 1, this trigger should modify the new discount percent 
by multiplying it by 100. That way, a discount percent of .2 becomes 20.
Test this trigger with an appropriate UPDATE statement.-----------------------------------------------------------------------------------------------------------------*/CREATE TRIGGER Products_UPDATEON Products AFTER UPDATEASBEGIN	DECLARE @DiscountCheck DECIMAL (10,2) = (SELECT DiscountPercent FROM PRODUCTS)  		IF @DiscountCheck > 0 AND @DiscountCheck < 1		DiscountPercent = @DiscountCheck * 100;	ELSE IF @DiscountCheck > 100 OR @DiscountCheck < 0		THROW 6001, 'Discount Cannot Be Over ListPrice',1;END/*---------------------------------------------------------------------------------------------------------------
5. Create a table named ProductsAudit. This table should have all columns of the Products table, except 
the Description column. Also, it should have an AuditID column for its primary key, and the 
DateAdded column should be changed to DateUpdated.
Create a trigger named Products_UPDATE. This trigger should insert the old data about the product 
into the ProductsAudit table after the row is updated. Then, test this trigger with an appropriate 
UPDATE statement-----------------------------------------------------------------------------------------------------------------*/ ---Create TableCREATE TABLE ProductsAudit	(		AuditID INT PRIMARY KEY,		ProductID INT NOT NULL, 		CategoryID INT REFERENCES Categories(CategoryID),		ProductCode NVARCHAR (10) NOT NULL UNIQUE,		ProductName NVARCHAR (100) NOT NULL,		ListPrice INT NOT NULL,		DiscountPercent Decimal (10, 2) NOT NULL DEFAULT 0.00,		DateUpdated Date NULL	);	SELECT *	FROM ProductsAudit	SELECT *	FROM Products	-- Trigger statementCREATE TRIGGER Products_UPDATE
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