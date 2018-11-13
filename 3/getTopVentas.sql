
--CREATE FUNCTION getTopVentas(int anio) RETURNS TABLE
--	BEGIN
--		return (select orderdate AS 'AÑO', 

select date_part, movietitle, sum(quantity)
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
group by date_part, movietitle
limit 10;