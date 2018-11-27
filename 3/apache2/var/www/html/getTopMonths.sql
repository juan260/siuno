

CREATE OR REPLACE FUNCTION getTopMonths (integer, integer) RETURNS table(
	year1 double precision,
	month1 text,
	quantity numeric,
	money numeric

)
	
	as $$
	declare
	BEGIN	
		
		return query select * from (select extract(YEAR from orderdate) as year, 
				      to_char(orderdate, 'Month') as month,  
					sum(ORDET.quantity) as quantity, sum(price) as money
                                	from orders as ORD,
                                        	orderdetail as ORDET
	                                where ORD.orderid = ORDET.orderid 
					group by year, month) as OrdersWithPrizesAndQuantities
					where OrdersWithPrizesAndQuantities.money > $2 or 
						OrdersWithPrizesAndQuantities.quantity > $1;

	
	END;
	$$ LANGUAGE 'plpgsql';


select * from getTopMonths(1, 2);

--DROP FUNCTION gettopmonths(integer, integer);


