select extract(YEAR from orderdate) as anio,
	     extract(MONTH from orderdate) as mes,
	     count(distinct(customerid))
	from orders
	where totalamount > 100
	group by (anio, mes)
	having (extract(YEAR from orderdate) = 2015 and
	extract(MONTH from orderdate) = 04);

explain select extract(YEAR from orderdate) as anio,
	     extract(MONTH from orderdate) as mes,
	     count(distinct(customerid))
	from orders
	where totalamount > 100
	group by (anio, mes)
	having (extract(YEAR from orderdate) = 2015 and
	extract(MONTH from orderdate) = 04);

DROP INDEX orders_date_index;

CREATE INDEX orders_date_index
ON orders(orderdate); -- Este no hace na

DROP INDEX orders_totamount_index;

CREATE INDEX orders_totamount_index
ON orders(totalamount); -- Este reduce un poquito en explain, no en pgadmin


DROP INDEX orders_id_index;

CREATE INDEX orders_id_index
ON orders(orderid);

explain select extract(YEAR from orderdate) as anio,
	     extract(MONTH from orderdate) as mes,
	     count(distinct(customerid))
	from orders
	where totalamount > 100
	group by (anio, mes)
	having (extract(YEAR from orderdate) = 2015 and
	extract(MONTH from orderdate) = 04);

	CREATE OR REPLACE FUNCTION clientesDistintos(amount integer, date1 integer) RETURNS table(
		  year1 double precision, month1 double precision,
		  count1 bigint
		) as $$
		declare
		BEGIN
			return query select extract(YEAR from orderdate) as anio,
				     extract(MONTH from orderdate) as mes,
				     count(distinct(customerid))
				from orders
				where totalamount > amount
				group by (anio, mes)
				having (extract(YEAR from orderdate) = date1/100 and
				extract(MONTH from orderdate) = (date1 % 100));
		END;
	$$ LANGUAGE 'plpgsql';
