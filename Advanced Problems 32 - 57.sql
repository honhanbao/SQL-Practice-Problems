
-- Advanved Problems 32 - 57

/*
32. High-value customers
We want to send all of our high-value customers a special VIP gift.
We're defining high-value customers as those who've made at least 1 order 
with a total value (not including the discount) equal to $5000 or more. 
We only want to consider orders made in the year 1997.
*/
-- Several queries server different questions here

	-- All orders of values more than 5000: change from 10000, due to dataset
	Select 
		Customers.CustomerID		'Customer ID'
		,Customers.CompanyName		'Company Name'
		,[Order Details].OrderID	'Order ID'
		,[Order Details].UnitPrice*[Order Details].Quantity*(1-[Order Details].Discount) 'Order Amount'
	From 
		[Order Details]
		Join Orders		On [Order Details].OrderID = Orders.OrderID
		Join Customers	On Customers.CustomerID = Orders.CustomerID
	Where Year(Convert(Date, Orders.OrderDate)) = 1997 
		and [Order Details].UnitPrice*[Order Details].Quantity*(1-[Order Details].Discount) >= 5000
	Order by 'Order Amount' desc;
	-- Order by Customers.CustomerID;
	


	-- Customers who have at least one order more than 5000: select distint from table above
	Select Distinct
		Sub.CustomerID		--'Customer ID'
		,Sub.CompanyName	--'Company Name'
	From 
		(Select 
			Customers.CustomerID		
			,Customers.CompanyName		
		From 
			[Order Details]
			Join Orders		On [Order Details].OrderID = Orders.OrderID
			Join Customers	On Customers.CustomerID = Orders.CustomerID
		Where Year(Convert(Date, Orders.OrderDate)) = 1997 
			and [Order Details].UnitPrice*[Order Details].Quantity*(1-[Order Details].Discount) >= 5000) as Sub
	Order by CustomerID;

/*
33 - 34. High-value customers - total orders with discount
The manager has changed his mind. Instead of requiring that customers
have at least one individual orders totaling $10,000 or more, he wants to
define high-value customers as those who have orders totaling $15,000
or more in 2016. How would you change the answer to the problem
above?
*/
	-- Customers who have total of orders more than 15000 after discount
	Select
		Customers.CustomerID		'Customer ID'
		,Customers.CompanyName		'Company Name'
		,Sum([Order Details].UnitPrice*[Order Details].Quantity*(1-[Order Details].Discount)) 'Total Order Amount'
	From 
		[Order Details]
		Join Orders On [Order Details].OrderID = Orders.OrderID
		Join Customers On Customers.CustomerID = Orders.CustomerID
	Where Year(Convert(Date, Orders.OrderDate)) = 1997 
	Group by 
		Customers.CustomerID
		,Customers.CompanyName
	Having
		Sum([Order Details].UnitPrice * [Order Details].Quantity * (1 - [Order Details].Discount)) > 15000
	Order by 
		'Total Order Amount' desc;


/*
35. Month-end orders
At the end of the month, salespeople are likely to try much 
harder to get orders, to meet their month-end quotas. 
Show all orders made on the last day of the month. 
Order by EmployeeID and OrderID
Note: Use function EOMONTH
*/
	Select 
		*
	From 
		Orders
	Where 
		Convert(Date, OrderDate) = EOMonth(Convert(Date, OrderDate))
	Order by 
		EmployeeID, OrderID;

/*
36. Orders with many line items
The Northwind mobile app developers are testing an app that customers
will use to show orders. In order to make sure that even the largest
orders will show up correctly on the app, they'd like some samples of
orders that have lots of individual line items. 
Show the 10 orders with the most line items, in order of total line items.

Explain: Each order may have more than one items.
*/
	Select Top 10
		OrderID			'Order ID'
		,Count(OrderID) 'Number of items'
	From 
		[Order Details]
	Group by OrderID
	Order by 'Number of items' desc;


/*
37. Orders - random assortment
The Northwind mobile app developers would now like to just get a
random assortment of orders for beta testing on their app. Show a
random set of 2% of all orders.
*/
	Select Top 2 Percent
		OrderID		'Order ID'
		,NewID()	'New ID'
	From Orders
	Order By NewID();

/*
38. Orders - accidental double-entry
Janet Leverling, one of the salespeople, has come to you with a request.
She thinks that she accidentally double-entered a line item on an order,
with a different ProductID, but the same quantity. 
She remembers that the quantity was 60 or more. 
Show all the OrderIDs with line items that match this, in order of OrderID.
*/
	Select 
		OrderID				'Order ID'
		,Quantity
		,Count(ProductID)	'Count'		-- different ProductID
	From 
		[Order Details]
	Where Quantity >= 60
	Group by OrderID, Quantity
		Having Count(ProductID) > 1				-- groups of more than 1 row
	Order by OrderID asc;

/*
39. Orders - accidental double-entry details
Based on the previous question, we now want to show details of the
order, for orders that match the above criteria.
*/
	Select
		*
	From 
		[Order Details]
	Where OrderId in
		(Select 
			OrderID	
		From 
			[Order Details]
		Where Quantity >= 60
		Group by OrderID, Quantity
			Having Count(ProductID) > 1);

/*
41. Late orders
Some customers are complaining about their orders arriving late. 
Which orders are late?
*/
	Select 
		*
	From 
		Orders
	Where RequiredDate <= ShippedDate;


/*
42. Late orders - which employees?
Some salespeople have more orders arriving late than others. Maybe
they're not following up on the order process, and need more training.
Which salespeople have the most orders arriving late?
-- having 3 or more
*/
	Select 
		Orders.EmployeeID		'Employee ID'
		,Employees.FirstName	'First Name'
		,Employees.LastName		'Last Name'
		,Count(OrderID)			'Count'
	From 
		Orders
		Join Employees
		On Orders.EmployeeID = Employees.EmployeeID 
	Where RequiredDate <= ShippedDate
	Group by Orders.EmployeeID, FirstName, LastName
	Having Count(OrderID) >= 3
	Order by Count(OrderID) desc;


/*
43. Late orders vs. total orders
Andrew, the VP of sales, has been doing some more thinking some more
about the problem of late orders. He realizes that just looking at the
number of orders arriving late for each salesperson isn't a good idea. It
needs to be compared against the total number of orders per salesperson.
Show all orders and late orders of Employees
*/
	
	With AllOrders as	-- All orders
		(Select 
			Orders.EmployeeID			'EmployeeID'
			,Employees.FirstName		'FirstName'
			,Employees.LastName			'LastName'
			,Count(Orders.EmployeeID)	'AllOrders'
		From 
			Orders
			Join Employees
			On Orders.EmployeeID = Employees.EmployeeID 
		Group by Orders.EmployeeID, Employees.FirstName, Employees.LastName)
	,LateOrders as		-- Late orders
		(Select 
			Orders.EmployeeID		'EmployeeID'
			,Count(OrderID)			'LateOrders'	
		From 
			Orders
			Join Employees
			On Orders.EmployeeID = Employees.EmployeeID 
		Where RequiredDate <= ShippedDate
		Group by Orders.EmployeeID, Employees.FirstName, Employees.LastName)
		--Having Count(OrderID) >= 3)
	Select				-- Result
		AllOrders.EmployeeID		'Employee ID'
		,AllOrders.FirstName		'First Name'
		,AllOrders.LastName			'Last Name'
		,AllOrders.AllOrders		'All Orders'
		,LateOrders.LateOrders		'Late Orders'
	From
		AllOrders
		Join LateOrders
		On AllOrders.EmployeeID = LateOrders.EmployeeID
	Order by AllOrders.AllOrders Desc;
		

/*

*/

/*

*/


/*

*/


/*

*/


/*

*/


/*

*/

/*

*/


/*

*/


/*

*/


/*

*/


/*

*/

/*

*/


/*

*/


/*

*/


/*

*/


/*

*/