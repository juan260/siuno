-- Juan Riera y Luis Cárabe
-- Script que calcula el precio que tenia cada producto
-- en la fecha en la que se vendio y guarda ese valor en la
-- tabla orderdetail
update
	orderdetail as DET
set
	price=PROD.price/(power(1.02,
		-- Current year
			date_part('year', current_timestamp)
			-
		-- Order year
			extract(YEAR from orderdate)))
from
	products as PROD,
	orders as ORD
where DET.prod_id=PROD.prod_id and
	ORD.orderid = DET.orderid;
