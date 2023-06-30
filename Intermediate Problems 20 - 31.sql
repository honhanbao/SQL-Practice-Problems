
-- Intermediate Problems 20-31

-- Note: some questions are modified, marked as "- modified"

/*
20. Categories, and the total products in each category
For this problem, we’d like to see the total number of products in each category. 
Sort the results by the total number of products, in descending order.
*/	
    --
	Select 
		c.CategoryName			 "Category Name"
		,count(p.Productname)	 "Total Producs"
	From 
		Categories c
		Join Products p
			On c.CategoryID = p.CategoryID
	Group by c.CategoryName;

	--
	Select 
		CategoryName			 "Category Name"
		,count(Productname)		 "Total Producs"
	From 
		Categories
		Join Products
			On Categories.CategoryID = Products.CategoryID
	Group by CategoryName;

/*
21. Total customers per country/city
In the Customers table, show the total number of customers per Country and City.
*/
	Select 
		Country
		,City
		,count(CustomerID) "Total Customers"
	From 
		Customers
	Group by Country, City
	Order by "Total Customers" desc;

/*
22. Products that need reordering
What products do we have in our inventory that should be reordered?
For now, just use the fields UnitsInStock and ReorderLevel, where
UnitsInStock is less than the ReorderLevel, ignoring the fields
UnitsOnOrder and Discontinued.
Order the results by ProductID.
*/
	Select
		ProductID		"Product ID"
		,ProductName	"Product Name"
		,UnitsInStock	"Units In Stock"
		,ReorderLevel	"Reorder Level"
	From Products
	Where UnitsInStock < ReorderLevel
	Order by ProductID asc;	

/*
23. Products that need reordering, continued
Now we need to incorporate these fields—UnitsInStock, UnitsOnOrder,
ReorderLevel, Discontinued—into our calculation. 
We’ll define “products that need reordering” with the following:
	-- UnitsInStock plus UnitsOnOrder are less than or equal to ReorderLevel
	-- The Discontinued flag is false (0).
*/
	Select
		ProductID		"Product ID"
		,ProductName	"Product Name"
		,UnitsInStock	"Units In Stock"
		,UnitsOnOrder	"Units On Order"
		,ReorderLevel	"Reorder Level"
		,Discontinued
	From Products
	Where 
		UnitsInStock + UnitsOnOrder <= ReorderLevel and
		Discontinued = 0	-- or 'false'
	Order by ProductID asc;	

/*
24. Customer list by region
A salesperson for Northwind is going on a business trip to visit customers, 
and would like to see a list of all customers, sorted by region, alphabetically.

However, he wants the customers with no region (null in the Region field) 
to be at the end, instead of at the top, where you’d normally find the null values. 
Within the same region, companies should be sorted by CustomerID.
*/
	Select 
		CustomerID		"Customer ID"
		,CompanyName	"Company Name"
		,Country
		,region
		,City
		,Address
		,Phone
	From Customers
	Order by 
		-- order Region with null at the bottom
		case
			when Region is not null then 0
			else 1
		end asc,
		Country,
		CustomerID asc;
		

	Select 
		CustomerID		"Customer ID"
		,CompanyName	"Company Name"
		,Country
		,region
		,City
		,Address
		,Phone
	From Customers
	Order by 
		-- order Region with null at the bottom but not-null is desc.
		Region desc,
		Country,
		CustomerID asc;


/*
25. High freight charges
Some of the countries we ship to have very high freight charges. 
We'd like to investigate some more shipping options for our customers, 
to be able to offer them lower freight charges. 
Return the three ship countries with the highest average freight overall, 
in descending order by average freight.
*/
	Select --Top 3 
		ShipCountry		'Ship Country'
		,AVG(Freight)	'Average Freight'
	From 
		Orders
	Group by ShipCountry
	Order by 'Average Freight' desc;

/*
26. High freight charges - 1996 - modified
We're continuing on the question above on high freight charges. 
Now, instead of using all the orders we have, 
we only want to see orders from the year 1996.
*/
	Select --Top 3 
		ShipCountry		'Ship Country'
		,AVG(Freight)	'Average Freight'
	From 
		Orders
	Where Year(OrderDate) = '1996'
	Group by ShipCountry
	Order by 'Average Freight' desc;

/*
27. High freight charges with between - First Quater 2017 - modified
*/
	Select --Top 3 
		ShipCountry		'Ship Country'
		,AVG(Freight)	'Average Freight'
	From 
		Orders
	Where Year(OrderDate) = '1997' and Month(OrderDate) between '01' and '03'
	--Where Year(OrderDate) = '1997' and Month(OrderDate) >= '01' and Month(OrderDate) <= '03'
	Group by ShipCountry
	Order by 'Average Freight' desc;

/*
28. High freight charges - last 12 months of data - modified
We're continuing to work on high freight charges. We now want to get
the three ship countries with the highest average freight charges. 
But instead of filtering for a particular year, we want to use the last 12
months of order data, using as the end date the last OrderDate in Orders.
Note: Range of date from a time can be used by DateAdd()
*/
	Select --Top 3 
		ShipCountry		'Ship Country'
		,AVG(Freight)	'Average Freight'
	From 
		Orders
	Where OrderDate >= DateAdd(Month, -12, (select max(OrderDate) from Orders))
	Group by ShipCountry
	Order by 'Average Freight' desc;

/*
29. Inventory list
We're doing inventory, and need to show information like the below, for all orders. 
Sort by OrderID and Product ID.
Note: 
	-- EmployeeID from Employees
	-- LastName from Employees
	-- OrderID from Orders
	-- ProductName from Products
	-- Quantity from 'Order Detals'
*/
	Select 
		Employees.EmployeeID	'Employee ID'
		,Employees.LastName		'Last Name'
		,Orders.OrderID			'Order ID'
		,Products.ProductName	'Product Name'
		,[Order Details].Quantity
	From
		Employees 
		Join Orders On Employees.EmployeeID = Orders.EmployeeID
		Join [Order Details] On [Order Details].OrderID = Orders.OrderID
		Join Products On Products.ProductID = [Order Details].ProductID;

/*
30. Customers with no orders
There are some customers who have never actually placed an order.
Show these customers.
Note: don't need to join as it make to code run slow: increase complexity.
*/
	Select 
		*
	From
		Customers
	Where Customers.CustomerID Not In (Select Orders.CustomerID from Orders);

/*
31. Customers with no orders for EmployeeID 4
One employee (Margaret Peacock, EmployeeID 4) has placed the most orders. 
However, there are some customers who've never placed an order with her. 
Show only those customers who have never placed an order with her.
*/
	-- Customers having orders with EmployeeID 4
	Select
		Customers.ContactName
	From 
		Customers Left Join Orders
			on Orders.CustomerID = Customers.CustomerID
				and Orders.EmployeeID = 4;
	
	-- Customers not in the list of Customers having orders with EmployeeID 4
	Select Distinct
		Customers.CustomerID
		,Customers.ContactName
	From
		Customers Left Join Orders 
			On Customers.CustomerID = Orders.CustomerID
	Where
		Customers.ContactName NOT IN (
			Select Customers.ContactName
			From Customers
				Lelf Join Orders 
					On Orders.CustomerID = Customers.CustomerID AND Orders.EmployeeID = 4);

	-- Alternately
	Select 
		Customers.CustomerID
		,Customers.ContactName
	From
		Customers
			Left Join Orders 
				On Customers.CustomerID = Orders.CustomerID AND Orders.EmployeeID = 4
	Where
		Orders.CustomerID IS NULL;
