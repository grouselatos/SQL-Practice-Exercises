use Northwind;
go

-- Exercise 1
--Select all category names with their descriptions from the Categories table.

SELECT CategoryName, Description FROM Categories;

--Exercise #2
--Select the contact name, customer id, and company name of all Customers in London

SELECT ContactName, CustomerID, CompanyName
FROM Customers
WHERE City = 'London';

--Exercise #3
--Marketing managers and sales representatives have asked you to select all available columns in the Suppliers tables that have a FAX number.

SELECT *
FROM Suppliers
WHERE Fax IS NOT NULL;

--Exercise #4
--Select a list of customers id’s from the Orders table with required dates between Jan 1, 1997 and Jan 1, 1998 and with freight under 100 units.

SELECT CustomerID
FROM Orders
WHERE RequiredDate BETWEEN '1997-01-01' and 'Jan 1, 1998'  AND Freight < 100;

--Exercise #5
--Select a list of company names and contact names of all the Owners from the Customer table from Mexico, Sweden and Germany.

select * from Customers;

SELECT CompanyName, ContactName
FROM Customers
WHERE Country IN ('Mexico', 'Sweden', 'Germany') AND ContactTitle = 'Owner';

--Exercise #6
--Count the number of discontinued products in the Products table.

SELECT COUNT(*)
FROM Products
WHERE Discontinued = 1;

--Exercise #7
--Select a list of category names and descriptions of all categories beginning with 'Co' from the Categories table.

SELECT [CategoryName], [Description]
FROM [Categories]
WHERE [CategoryName] LIKE 'Co%';

--Exercise #8
--Select all the company names, city, country and postal code from the Suppliers table with the word 'rue' in their address. The list should be ordered alphabetically by company name.

SELECT CompanyName, City, Country, PostalCode
FROM Suppliers
WHERE Address LIKE '%rue%'
ORDER BY CompanyName;

--Exercise #9
--Select the product id and the total quantities ordered for each product id in the Order Details table.

select * from [Order Details]

SELECT ProductID AS [Product ID], SUM(Quantity) AS [Total Quantity]
FROM [Order Details]
GROUP BY ProductID
ORDER BY [Total Quantity]

--Exercise #10
--Select the customer name and customer address of all customers with orders that shipped using Speedy Express.

--1st way
SELECT ContactName, Address
FROM Customers
WHERE CustomerID IN 
	(SELECT DISTINCT CustomerID
	 FROM Orders
	 WHERE ShipVia IN 
		(SELECT ShipperID 
		 FROM Shippers
		 WHERE CompanyName = 'Speedy Express'))

--2nd way
SELECT DISTINCT Customers.ContactName, Customers.Address
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
INNER JOIN Shippers
ON Orders.ShipVia = Shippers.ShipperID
WHERE Shippers.CompanyName = 'Speedy Express'

--Exercise #11
--Select a list of Suppliers containing company name, contact name, contact title and region description.

SELECT CompanyName, ContactName, ContactTitle, Region
FROM Suppliers
WHERE ContactName IS NOT NULL AND ContactTitle IS NOT NULL AND Region IS NOT NULL

--Exercise #12
--Select all product names from the Products table that are condiments.

-- 1st way
SELECT ProductName
FROM Products
WHERE CategoryID IN 
	(SELECT CategoryID
	 FROM Categories
	 WHERE CategoryName = 'Condiments');


--2nd way
SELECT Products.ProductName
FROM Products
INNER JOIN Categories
ON Products.CategoryID = Categories.CategoryID
WHERE Categories.CategoryName = 'Condiments'

--Exercise #13
--Select a list of customer names who have no orders in the Orders table.

SELECT ContactName
FROM Customers
WHERE CustomerID NOT IN 
	(SELECT DISTINCT CustomerID
	 FROM Orders);
