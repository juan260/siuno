

CREATE OR REPLACE FUNCTION getTopMonths (integer, integer) RETURNS table(
	date_part1 double precision,
	movietitle1 VARCHAR(255),
	sum1 BIGINT

)
	
	as $$
	declare
	BEGIN	
		
		return query select year1, month1, sum(quantity) as quant, sum(money) as price
                	from (select extract(YEAR from orderdate) as year1, extract(MONTH from orderdate) as month1, 
					movieid, quantity
                        	from (select ORD.orderdate, quantity, price as money
                                	from orders as ORD,
                                        	orderdetail as ORDET
	                                where ORD.orderid = ORDET.orderid)
        	                		as YearMovIdAndQuantity,
                                	group by year1, month1
					where quant>$1 or price>$2;

	
	END;
	$$ LANGUAGE 'plpgsql';


select getTopMonths(1, 2);

DROP FUNCTION gettopmonths(integer, integer);


