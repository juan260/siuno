

CREATE OR REPLACE FUNCTION getTopVentas (integer) RETURNS table(
	date_part1 double precision,
	movietitle1 VARCHAR(255),
	sum1 BIGINT

)
	
	as $$
	declare
	BEGIN	
		--DROP IF EXISTS VIEW dateMovieQuantity;
		CREATE OR REPLACE VIEW dateMovieQuantity as
			select date_part, movietitle, sum(quantity) as quant
        --      return query select 1 as caca
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
        	        group by date_part, movietitle;

		return query select maximized.date_part as año, normal.movietitle as pelicula, maximized.quant as ventas 
			from (select date_part, max(quant) as quant from dateMovieQuantity
				group by date_part) AS maximized JOIN 
					dateMovieQuantity AS normal ON maximized.date_part = normal.date_part and 
						maximized.quant = normal.quant 
						where maximized.date_part>$1;
	
	END;
	$$ LANGUAGE 'plpgsql';


select getTopVentas(2015);

--DROP FUNCTION gettopventas(integer);



