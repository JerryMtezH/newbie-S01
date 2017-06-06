insert into Orders
  (CustomerID,OrderDate,RequiredDate,ShippedDate)
  values
  (3,'2017-06-01','2017-07-01','2017-06-15');
   
select * from orders;

insert into OrderDetails
  (orderid,productid,unitprice,Quantity)
  values
  (3,125,15.2,5);
 
insert into OrderDetails
  (orderid,productid,unitprice,Quantity)
  values
  (3,126,13.2,5);
 
select * from OrderDetails;

insert into customers
  (companyname, contactname,contacttitle,address,city,state)
  values
  ('Kaizendynets.com','Alejandro Antiga','Sales Manager',
  'Calle 1','Mexico','CDMX');

select * from orders where customerid in
  (select customerid from customers where 
  companyname = 'Floor Co.');

select * from orders where customerid in
  (select customerid from customers where 
  companyname = 'Floor Co.') and 
  substr(OrderDate,1,4)='2013';  

select customerid from orders where customerid in
  (select customerid from customers where 
  companyname = 'Floor Co.') and 
  substr(OrderDate,1,4)='2013';  

update orders 
  set customerid=6
  where customerid in
  (select customerid from customers where 
  companyname = 'Floor Co.') and 
  substr(OrderDate,1,4)='2013';  


select * from OrderDetails
  where orderid in
    (select orderid from orders 
     where customerid in
       (select customerid from customers
        where companyname = 'Slots Carpet'));

delete from OrderDetails
  where orderid in
    (select orderid from orders 
     where customerid in
       (select customerid from customers
        where companyname = 'Slots Carpet'));

select orderid from orders
  where customerid in
    (select customerid from customers
     where companyname = 'Slots Carpet');

delete from orders
  where customerid in
    (select customerid from customers
     where companyname = 'Slots Carpet');

delete from customers
  where companyname = 'Slots Carpet';