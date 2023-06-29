-- 20. Categories, and the total products in each category
-- For this problem, we’d like to see the total number of products in each category. 
-- Sort the results by the total number of products, in descending order.
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

-- 21. Total customers per country/city
-- In the Customers table, show the total number of customers per Country and City.
	Select 
		Country
		,City
		,count(CustomerID) "Total Customers"
	From 
		Customers
	Group by Country, City
	Order by "Total Customers" desc;

-- 22. Products that need reordering
-- What products do we have in our inventory that should be reordered?
-- For now, just use the fields UnitsInStock and ReorderLevel, where
-- UnitsInStock is less than the ReorderLevel, ignoring the fields
-- UnitsOnOrder and Discontinued.
-- Order the results by ProductID.
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
However, he wants the customers with no region (null in the Region
field) to be at the end, instead of at the top, where you’d normally find
the null values. Within the same region, companies should be sorted by
CustomerID.
*/