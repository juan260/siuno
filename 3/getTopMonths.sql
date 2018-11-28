-- Juan Riera y Luis Cárabe
﻿
-- Funcion que dados dos enteros, una cantidad primero
-- y una cantidad de dinero como segundo argumento,
-- devuelve el mes de los anios en los que se supero
-- o la cuantia del primer argumento o la cuantia economica
-- del segundo argumento.
CREATE
OR REPLACE FUNCTION getTopMonths (integer, integer) RETURNS table(
  year1 double precision, month1 text,
  quantity numeric, money numeric
) as $$ declare BEGIN return query
select
  *
from
  (
  	-- Las ganancias economicas y las cantidades de ventas
	-- agrupados por meses y anios
    select
      extract(
        YEAR
        from
          orderdate
      ) as year,
      to_char(orderdate, 'Month') as month,
      sum(ORDET.quantity) as quantity,
      sum(price) as money
    from
      orders as ORD,
      orderdetail as ORDET
    where
      ORD.orderid = ORDET.orderid
    group by
      year,
      month
  ) as OrdersWithPrizesAndQuantities
where
  OrdersWithPrizesAndQuantities.money > $2
  or OrdersWithPrizesAndQuantities.quantity > $1;
END;
$$ LANGUAGE 'plpgsql';
>>>>>>> 4cde5b24af89ec913f8a129b8d46f795aaad157c
