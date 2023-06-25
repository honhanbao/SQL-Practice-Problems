-- 1 - Which shippers do we have?
-- We have a table called Shippers. Return all the fields from all the shippers

	-- Simply select all
	Select * from Shippers;

-- 2. Certain fields from Categories
-- Show two fields CategoryName and Description from Caterogies
	Select 
		CategoryName "Category Name",	-- rename column for display
		Description
	From Categories;

-- 3. Sales Representatives
-- We’d like to see just the FirstName, LastName, and HireDate of 
-- all the employees with the Title of Sales Representative. 
-- Extra condition: employed in or after 1993
	Select 
		FirstName	"First Name", 
		LastName	"Last Name",
		DateFromParts(Year(HireDate), Month(HireDate), Day(HireDate))	"Hire Date"
	From Employees
	Where Title = 'Sales Representative' and Year(HireDate) >= 1993;

-- 4. Sales Representatives in the United States
-- Now we’d like to see the same columns as above, but only for those employees 
-- that both have the title of Sales Representative, and also are in the United States.
	Select 
		FirstName	"First Name", 
		LastName	"Last Name",
		DateFromParts(Year(HireDate), Month(HireDate), Day(HireDate))	"Hire Date"
	From Employees
	Where Title = 'Sales Representative' and Country = 'USA';

-- 5. Orders placed by specific EmployeeID
-- Show all the orders placed by a specific employee. 
-- The EmployeeID for this Employee (Steven Buchanan) is 5.
	Select 
		OrderID		"Order ID",
		OrderDate	"Order Date",
		Freight
	From Orders
	Where EmployeeID = 5;

-- 6. Suppliers and ContactTitles
-- In the Suppliers table, show the SupplierID, ContactName, and ContactTitle 
-- for those Suppliers whose ContactTitle is not Marketing Manager.
	Select 
		SupplierID		"Supplier ID", 
		ContactName		"Contact Name", 
		ContactTitle	"Contact Title"
	From Suppliers
	Where ContactTitle != 'Marketing Manager';

-- 7. Products with “queso” in ProductName
-- In the products table, we’d like to see the ProductID and ProductName
-- for those products where the ProductName includes the string “queso”.
	Select 
		ProductID		"Product ID",
		ProductName		"Product Name"
	From Products
	Where Charindex('queso', lower(ProductName)) > 0;

-- for those products where the ProductName starting with “Queso”.
-- Using wildcard 
	Select 
		ProductID		"Product ID",
		ProductName		"Product Name"
	From Products
	Where ProductName Like 'Queso%';

-- for those products where the ProductName starting with “A - H”.
-- Using wildcard 
	Select 
		ProductID		"Product ID",
		ProductName		"Product Name"
	From Products
	Where ProductName Like '[A-H]%';

-- for those products where the ProductName NOT starting with “A - H”.
-- Using wildcard 
	Select 
		ProductID		"Product ID",
		ProductName		"Product Name"
	From Products
	Where ProductName Like '[^A-H]%';

-- 8 - 9. Orders shipping to France or Belgium
-- Looking at the Orders table, there’s a field called ShipCountry. Write a
-- query that shows the OrderID, CustomerID, and ShipCountry for the
-- orders where the ShipCountry is either France or Belgium.
	Select 
		OrderID		"Order ID",
		CustomerID	"Customer ID",
		ShipCountry "Ship Country"
	From Orders
	Where ShipCountry In ('France', 'Belgium');

-- 10 - 11. Employees, in order of age
-- For all the employees in the Employees table, show the FirstName,
-- LastName, Title, and BirthDate. Order the results by BirthDate, so we
-- have the oldest employees first.
	Select 
		FirstName	"First Name", 
		LastName	"Last Name", 
		Title,
		DateFromParts(Year(BirthDate), Month(BirthDate), Day(BirthDate))	"Birth Date"
	From Employees
	Order By BirthDate;

-- 12. Employees full name
-- Show the FirstName and LastName columns from the Employees table,
-- and then create a new column called FullName, showing FirstName and
-- LastName joined together in one column, with a space in-between.
-- Modified: show full name, title, and birth day
	Select 
		Concat(FirstName, ' ', LastName)	"Full Name", 
		Title,
		DateFromParts(Year(BirthDate), Month(BirthDate), Day(BirthDate))	"Birth Date"
	From Employees;

13. OrderDetails amount per line item
In the OrderDetails table, we have the fields UnitPrice and Quantity.
Create a new field, TotalPrice, that multiplies these two together. We’ll
ignore the Discount field for now.
In addition, show the OrderID, ProductID, UnitPrice, and Quantity.
Order by OrderID and ProductID.