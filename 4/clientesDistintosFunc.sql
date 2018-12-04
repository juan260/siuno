CREATE INDEX orders_date_index
ON orders(orderdate); -- Este no hace na


CREATE INDEX orders_totamount_index
ON orders(totalamount); -- Este reduce un poquito en explain, no en pgadmin

CREATE INDEX orders_id_index
ON orders(orderid);

CREATE OR REPLACE FUNCTION clientesDistintos(amount integer, date1 integer) RETURNS integer as $$
	declare
	BEGIN
		return  (select cc from (select extract(YEAR from orderdate) as anio,
				extract(MONTH from orderdate) as mes,
			count(distinct(customerid)) as cc
			from orders
			where totalamount > amount
			group by (anio, mes)
			having (extract(YEAR from orderdate) = date1/100 and
			extract(MONTH from orderdate) = (date1 % 100))) as aux);
	END;
$$ LANGUAGE 'plpgsql';
