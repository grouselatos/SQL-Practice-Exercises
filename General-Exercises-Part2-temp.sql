use Northwind;
go

--Exercise #1
--Select the name, address, city, and region of employees.


SELECT FirstName, Address, City, ISNULL(Region, '-') as [Region]
FROM Employees


--Exercise #2
--Select the name, address, city, and region of employees living in USA

SELECT FirstName, [Address], City, ISNULL(Region, ' - ') AS [Region]
FROM Employees
WHERE Country = 'USA';

--Exercise #3
--Select the name, address, city, and region of employees older than 50 years old.
SELECT FirstName, [Address], City, ISNULL(Region, ' - ') AS [Region]
FROM Employees
WHERE BirthDate < '1969-06-06'

SELECT LastName, FirstName, [Address], City, ISNULL(Region, ' - ') AS [Region]
FROM Employees
WHERE DATEDIFF(year, BirthDate , GETDATE()) > 50;

--Exercise #4
--Select the name, address, city, and region of employees that have placed orders to be delivered in Belgium. Write two versions of the query, with and without join.


SELECT LastName, FirstName, [Address], City, ISNULL(Region, ' - ') AS [Region]
FROM Employees
WHERE EmployeeID IN
	(SELECT DISTINCT EmployeeID
	 FROM Orders
	 WHERE ShipCountry = 'Belgium')

SELECT DISTINCT e.LastName, e.FirstName, e.[Address], e.City, ISNULL(e.Region, ' - ') AS [Region]
FROM Employees AS e
INNER JOIN Orders AS o
ON e.EmployeeID = o.EmployeeID
WHERE o.ShipCountry = 'Belgium'

--Exercise #5
--Select the employee name and the customer name for orders that are sent by the company �Speedy Express� to customers who live in Brussels.

SELECT DISTINCT e.LastName, e.FirstName, c.ContactName
FROM Employees e
JOIN Orders AS o ON o.EmployeeID = e.EmployeeID
JOIN Customers AS c ON o.CustomerID = c.CustomerID
JOIN Shippers AS s ON o.ShipVia = s.ShipperID
WHERE s.CompanyName ='Speedy Express' AND c.City = 'Bruxelles';

--Exercise #6
--Select the title and name of employees who have sold at least one of the products �Gravad Lax� or �Mishi Kobe Niku�.

SELECT DISTINCT Employees.LastName, Employees.FirstName, Employees.Title
FROM Employees
INNER JOIN Orders ON Orders.EmployeeID = Employees.EmployeeID
INNER JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
WHERE Products.ProductName IN ('Gravad Lax', 'Mishi Kobe Niku')


--Exercise #7
--Select the name and title of employees and the name and title of the person to which they refer (or null for the latter values if they don�t refer to another employee).

SELECT e.FirstName as [Employee Name], e.LastName as [Employee Lastname], b.LastName as [Reports To]
FROM Employees AS e
LEFT OUTER JOIN Employees AS b
ON e.ReportsTo = b.EmployeeID

--Exercise #8
--Select the customer name, the product name and the supplier name for customers who live in London and suppliers whose name is �Pavlova, Ltd.� or �Karkki Oy�.

SELECT DISTINCT c.ContactName AS [Customer], p.ProductName AS [Product], s.ContactName AS [Supplier]
FROM Customers AS c
JOIN Orders AS o ON o.CustomerID = c.CustomerID
JOIN [Order Details] AS od ON od.OrderID = o.OrderID
JOIN Products AS p ON p.ProductID = od.ProductID
JOIN Suppliers AS s ON s.SupplierID = p.SupplierID
WHERE c.City = 'London' AND s.CompanyName IN ('Pavlova, Ltd.', 'Karkki Oy');

--Exercise #9
--Select the name of products that were bought or sold by people who live in London. 

SELECT DISTINCT p.ProductName
FROM Products p 
JOIN [Order Details] od ON od.ProductID = p.ProductID
JOIN Orders o ON o.OrderID = od.OrderID
JOIN Employees e ON e.EmployeeID = o.EmployeeID
JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE c.City = 'London' OR e.City = 'London';

--Exercise #10
--Select the names of employees who are strictly older than: (a) any employee who lives in London. (b) all employees who live in London.

SELECT LastName, FirstName
FROM Employees
WHERE BirthDate < ANY (SELECT BirthDate FROM Employees WHERE City = 'London');

SELECT LastName, FirstName
FROM Employees 
WHERE BirthDate < ALL (SELECT BirthDate FROM Employees WHERE City = 'London');

--Exercise #11
--Select the name of employees who work longer than any employee of London.

SELECT LastName, FirstName
FROM Employees
WHERE HireDate < ALL (SELECT HireDate FROM Employees WHERE City = 'London');

--Exercise #12
--Select the name of employees and the city where they live for employees who have sold to customers in the same city.

SELECT DISTINCT e.LastName, e.FirstName, e.City
FROM Employees e
JOIN Orders o ON o.EmployeeID = e.EmployeeID
JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE e.City = c.City;

--EXTRA: Select the name of employees and the city where they live if any customer lives in the same city

SELECT DISTINCT CONCAT(e.LastName, ' ', e.FirstName) AS Employee, e.City
FROM Employees e
JOIN Customers c ON e.City = c.City

--Exercise #13
--Select the name of customers who have not purchased any product.
--1st way
SELECT DISTINCT ContactName
FROM Customers 
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);

--2nd way
SELECT DISTINCT Customers.ContactName
FROM Customers
LEFT JOIN Orders ON Orders.CustomerID = Customers.CustomerID
WHERE Orders.OrderID IS NULL

--Exercise #14
--Select the name of customers who bought only products with price less than 50.

--1st way
SELECT DISTINCT Customers.ContactName
FROM Customers
INNER JOIN Orders ON Orders.CustomerID = Customers.CustomerID
INNER JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
INNER JOIN Products ON Products.ProductID = [Order Details].ProductID
GROUP BY Customers.ContactName
HAVING MAX(Products.UnitPrice) < 50;

--2nd way
SELECT ContactName
FROM Customers
WHERE CustomerID NOT IN 
	(SELECT DISTINCT Customers.CustomerID
	FROM Customers
	INNER JOIN Orders ON Orders.CustomerID = Customers.CustomerID
	INNER JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
	INNER JOIN Products ON Products.ProductID = [Order Details].ProductID
	WHERE Products.UnitPrice >= 50)
AND CustomerID IN (SELECT DISTINCT CustomerID FROM Orders);

--Exercise #15
--Select the name of the products sold by all employees.

SELECT p.ProductName
FROM Products AS p
JOIN [Order Details] AS od ON p.ProductID = od.ProductID
JOIN Orders AS o ON od.OrderID = o.OrderID
GROUP BY p.ProductName
HAVING COUNT(DISTINCT o.EmployeeID) = (SELECT COUNT(*) FROM Employees)