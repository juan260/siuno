explain select extract(YEAR from orderdate) as anio,
	     extract(MONTH from orderdate) as mes,
	     count(distinct(customerid))
	from orders
	where totalamount > 100
	group by (anio, mes)
	having (extract(YEAR from orderdate) = 2015 and
	extract(MONTH from orderdate) = 04);
	
