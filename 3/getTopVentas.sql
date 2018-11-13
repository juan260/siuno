
DROP FUNCTION gettopventas(integer);
CREATE OR REPLACE FUNCTION getTopVentas (integer) RETURNS table(
	date_part1 double precision,
	sum1 BIGINT,
	movietitle1 text
)
	
	as $$
	declare
	BEGIN	
	return query select date_part as año, max(quant) as ventas, max(movietitle) as pelicula 
		from (select date_part, movietitle, sum(quantity) as quant
	--	return query select 1 as caca
		from (select extract(YEAR from orderdate), movieid, quantity
			from (select ORD.orderdate, ORDET.prod_id, quantity
				from orders as ORD,
					orderdetail as ORDET
				where ORD.orderid = ORDET.orderid)
			as OrdersAndProducts,
				products as PRODS
			where PRODS.prod_id = OrdersAndProducts.prod_id) as YearMovIdAndQuantity,
				imdb_movies as MOVIES
		where YearMovIdAndQuantity.movieid = MOVIES.movieid
		group by date_part, movietitle) as DateMovieQuantity
		group by date_part
	limit 10;
	
	END;
	$$ LANGUAGE 'plpgsql';


select getTopVentas(1);



