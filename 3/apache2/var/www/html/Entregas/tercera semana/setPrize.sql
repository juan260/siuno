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