select count(*) from Orders where CustomerID=3;

select count(*) from Orders where CustomerID =
  (select CustomerID from Customers where
  ContactName =  'Jim Wood');

select count(*) from Orders where CustomerID =
  (select CustomerID from Customers where
  CompanyName = 'Slots Carpet');

select b.CompanyName, count(a.OrderID) "Ordenes" from 
  Orders a left join Customers b on 
  a.CustomerID = b.CustomerID
  group by
  a.CustomerID
  order by "Ordenes" desc; 

select b.CompanyName, count(a.OrderID) "Ordenes" from 
  Orders a left join Customers b on 
  a.CustomerID = b.CustomerID
  group by
  a.CustomerID
  order by "Ordenes"; 

select b.CompanyName, count(a.OrderID) "Ordenes" from 
  Orders a left join Customers b on 
  a.CustomerID = b.CustomerID
  group by
  a.CustomerID
  order by "Ordenes" desc
  Limit 1; 

select b.CompanyName, sum(c.Quantity) "Articulos" from 
  Orders a left join Customers b on 
  a.CustomerID = b.CustomerID
  left join OrderDetails c on 
  a.OrderID = c.OrderID
  group by
  a.CustomerID
  order by "Articulos" desc;

select OrderID, sum(UnitPrice*Quantity) "Total" from OrderDetails
  group by 
  OrderID
  order by
  OrderID;

select OrderID, sum(UnitPrice*Quantity) AS amount from OrderDetails
  group by 
  OrderID
  having amount > 1000
  order by
  OrderID;

select OrderID, sum(Quantity) "Total" from OrderDetails
  group by 
  OrderID
  order by
  OrderID;