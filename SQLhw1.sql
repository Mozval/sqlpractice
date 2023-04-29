---1---
select
ProductName,
UnitPrice,
CategoryID
from Products
where CategoryID =1
order by UnitPrice desc
---2---
select top 1
ProductName,
UnitPrice,
CategoryID
from Products
where CategoryID=1
order by UnitPrice
---3---
select top 1 (select top 1 UnitPrice from Products
where CategoryID = (select top 1 CategoryID from Products order by UnitPrice desc) 
order by UnitPrice desc)-(select top 1 UnitPrice from Products 
where CategoryID = (select top 1 CategoryID from Products order by UnitPrice desc) order by UnitPrice) as 'max-min'
from Products
---4---

select * from Customers 
where city in 
(select City 
from Customers
where CustomerID not in (select CustomerID from Orders))
---5---
select
ProductID,
CategoryID
from Products
order by UnitPrice desc
offset 4 rows
fetch next 1 row only

select
ProductID,
CategoryID
from Products
order by UnitPrice 
offset 7 rows
fetch next 1 row only
---6---
select
ProductID,
CategoryID
from Products
order by UnitPrice desc
offset 4 rows
fetch next 1 row only

select
ProductID,
CategoryID
from Products
order by UnitPrice 
offset 7 rows
fetch next 1 row only

select
od.ProductID,
c.ContactName
from Customers c
inner join Orders o on c.CustomerID=o.CustomerID
inner join [Order Details] od on o.OrderID=od.OrderID
where ProductID=59 or  ProductID=1
---7---
select LastName, FirstName 
from Employees 
where EmployeeID in (select EmployeeID from Northwind.dbo.Orders where OrderID 
in (select OrderID from [Order Details] 
where
ProductID = (select ProductID from Products order by UnitPrice desc offset 4 rows fetch next 1 rows only)));
select LastName, FirstName from Employees where EmployeeID 
in (select EmployeeID from Orders where OrderID in (select OrderID from [Order Details] 
where ProductID = (select ProductID from Products order by UnitPrice offset 7 rows fetch next 1 rows only)));
---8---
select * from 
Orders where day(OrderDate) = 13 and datepart(weekday,OrderDate) = 6;
---9---
select
c.ContactName,
o.OrderDate
from Customers c
inner join Orders o on c.CustomerID=o.CustomerID
where day(OrderDate) = 13 and datepart(weekday,OrderDate) = 6;
---10---
select c.ContactName,
od.ProductID,
o.OrderDate
from Orders o
inner join [Order Details] od on od.OrderID=o.OrderID
inner join Customers c on c.CustomerID=o.CustomerID
where day(OrderDate) = 13 and datepart(weekday,OrderDate) = 6;
---11---
select 
ProductID,
Discontinued
from Products
where Discontinued=0
---12---
select distinct c.CustomerID, c.ContactName, c.City
from Customers c
inner join Orders o on o.CustomerID = c.CustomerID
inner join [Order Details] od on od.OrderID = o.OrderID
inner join Products p on p.ProductID = od.ProductID
inner join Suppliers s on s.SupplierID = p.SupplierID
where(s.Country <> c.Country)

---13---
select c.ContactName, c.City from Customers c inner join Employees e on c.City = e.City
---14---
select p.ProductID
from Products p
where not exists(
select od.ProductID
from [Order Details] od
)
---15---
select o.OrderDate, o.OrderID
from Orders o
where DATEPART(day,o.OrderDate) >= 20 
---16---
select distinct ProductName from [Order Details] o 
inner join Products p on o.ProductID = p.ProductID
where OrderID in (select OrderID from Orders where OrderDate = eomonth(OrderDate))
---17---
select top 3 c.CustomerID, sum((od.UnitPrice * od.Quantity) * (1- od.Discount)) totalprice
from [Order Details] od
inner join Orders o on o.OrderID = od.OrderID
inner join Customers c on c.CustomerID = o.CustomerID
WHERE c.CustomerID in(
	select distinct c.CustomerID
	from Customers c
inner join Orders o ON o.CustomerID = c.CustomerID
	inner join [Order Details] od on od.ProductID IN (
	select top 3 p.ProductID
		from Products p
		order by p.UnitPrice desc
	)
)
group by c.CustomerID
order by totalprice desc;
---18---
select ContactName from Customers 
where CustomerID in (select top 3 CustomerID from [Order Details] o1 inner join Orders o2 on o1.OrderID = o2.OrderID where ProductID in (select top 3 ProductID 
from Products order by UnitPrice desc) order by UnitPrice*Quantity*(1-Discount) desc);
---19---
select top 3 c.CustomerID, sum((od.UnitPrice * od.Quantity) * (1- od.Discount)) totalprice
from Customers c
inner join Orders o on o.CustomerID = c.CustomerID
inner join [Order Details] od on od.OrderID = o.OrderID
inner join Products p on p.ProductID = od.ProductID
inner join Categories cc on cc.CategoryID = p.CategoryID
where cc.CategoryID in(
	select cc.CategoryID
from Categories cc
	inner join Products p ON p.CategoryID = cc.CategoryID
	where p.ProductID in(
		select top 3 od.ProductID
		from [Order Details] od
		group by od.ProductID
		order by  sum((od.UnitPrice*od.Quantity)*(1-od.Discount))desc
	)
)
group by c.CustomerID
order by totalprice desc;
---20---
select o1.OrderID, 
sum(UnitPrice*Quantity*(1-Discount)) as total 
from [Order Details] o1 
group by o1.OrderID having sum(UnitPrice*Quantity*(1-Discount)) > (select avg(UnitPrice*Quantity*(1-Discount)) as total 
from [Order Details]) order by OrderID;
select OrderID, ContactName from Customers c
inner join Orders o on o.CustomerID = c.CustomerID 
where OrderID in (select o1.OrderID from [Order Details] o1
group by o1.OrderID having sum(UnitPrice*Quantity*(1-Discount)) > (select avg(UnitPrice*Quantity*(1-Discount)) as total 
from [Order Details])) order by OrderID;
---21---
select top 1 sum(od.UnitPrice)  sumprice, od.ProductID
from [Order Details] od
group by od.ProductID
order by sum(od.Quantity) desc
---22---
select top 1 ProductID,sum(Quantity)
from [Order Details]
group by ProductID
order by  sum(Quantity) 
---23---
select top 1 sum(Quantity) as quantity, p.CategoryID from 
[Order Details] o inner join Products p on o.ProductID = p.ProductID group by p.CategoryID order by sum(Quantity)
---24---
select top 1 s.SupplierID, sum(od.Quantity)
from Suppliers s
inner join Products p on p.SupplierID = s.SupplierID
inner join [Order Details] od on od.ProductID = p.ProductID
group by s.SupplierID
order by sum(od.Quantity) desc
---25---
select top 1 c.CustomerID
from Customers c
inner join Orders o on c.CustomerID = o.CustomerID
inner join [Order Details] od on od.OrderID = o.OrderID
inner join Products p on p.SupplierID = od.ProductID
inner join Suppliers s on s.SupplierID = p.SupplierID
where s.SupplierID = 12
order by od.Quantity desc

---26---
select p.ProductID
from Products p
where not exists(
select od.ProductID
from [Order Details] od
)
---27---
select CustomerID, sum(UnitPrice*Quantity*(1-Discount)) as total 
from [Order Details] o1 inner join Orders o2 on o1.OrderID = o2.OrderID 
where o2.CustomerID in (select CustomerID from Customers where fax is null) group by o2.CustomerID
---28---
select c.City, p.CategoryID, sum(o2.Quantity) as Quantity 
from Orders o1 left join [Order Details] o2 on o1.OrderID = o2.OrderID left join Customers c 
on o1.CustomerID = c.CustomerID left join Products p on o2.ProductID = p.ProductID 
group by c.City, p.CategoryID order by c.City
---29---
select p.ProductID, sum(od.Quantity)
from Products p
inner join [Order Details] od on od.ProductID = p.ProductID
where p.UnitsInStock = 0
group by p.ProductID
---30---
select distinct o.CustomerID
from Products p
inner join [Order Details] od on od.ProductID = p.ProductID
inner join Orders o on o.OrderID = od.OrderID
where p.UnitsInStock = 0
---31---
select e.ReportsTo EmployeeID ,sum(od.Quantity*od.UnitPrice*(1-od.Discount)) totalach
from Employees e
inner join Orders o on o.EmployeeID = e.EmployeeID
inner join [Order Details] od on od.OrderID = o.OrderID
where e.ReportsTo is not null
group by e.ReportsTo;
--32---
with added_row_number as (select ShipName, CategoryID, sum(Quantity) as all_quantity, row_number() over(partition 
by ShipName order by ShipName, sum(Quantity) desc)as row_number
from Orders o1 left join Northwind.dbo.[Order Details] o2 on o1.OrderID = o2.OrderID
left join Products p on o2.ProductID = p.ProductID where o1.ShipName is not null group by ShipName, CategoryID)
select * from added_row_number where row_number = 1;
---33---
with added_row_number as (select c.ContactName, p.CategoryID, sum(Quantity) as Quantity, sum(o1.UnitPrice*Quantity*(1-Discount)) 
as total, row_number() over(partition by ContactName order by sum(Quantity) desc)as row_number 
from [Order Details] o1 left join Orders o2 on o1.OrderID = o2.OrderID 
left join Customers c on c.CustomerID = o2.CustomerID left join Products p on o1.ProductID = p.ProductID group by c.ContactName, p.CategoryID)
select * from added_row_number where row_number = 1;
---34---
with added_row_number as (select c.ContactName, p.ProductName, sum(Quantity) as Quantity, row_number() over(partition by
ContactName order by c.ContactName, sum(Quantity) desc)as row_number 
from [Order Details] o1 left join Orders o2 on o1.OrderID = o2.OrderID 
left join Customers c on c.CustomerID = o2.CustomerID left join Products p on o1.ProductID = p.ProductID
group by c.ContactName, p.ProductName)
select * from added_row_number where row_number = 1;
---35---
select o.ShipCity, max(o.ShippedDate)
from Orders o
group by o.ShipCity
---36---









