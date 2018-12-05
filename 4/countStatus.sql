explain select count(*) 
from orders 
where status is null;
-- aggregate cost=3507.17..3507.18 antes de indice
-- seq scan cost=0.00..3504.90


explain select count(*) 
from orders 
where status ='Shipped';
-- aggregate cost=3961.65..3961.66 antes del indice
-- seq scan cost=0.00..3959.38

CREATE INDEX orders_status_index
ON orders(status);

explain select count(*) 
from orders 
where status is null;
-- aggregate cost=1496.53..1496.53 despues de indice
-- bitmap  cost=19.46..1494.25
-- bitmap cost=0.00..19.24


explain select count(*) 
from orders 
where status ='Shipped';
-- aggregate cost=1498.79..1498.80 despues del indice
-- bitmap  cost=19.46..1496.52
-- bitmap cost=0.00..19.24

ANALYZE orders;

explain select count(*) 
from orders 
where status is null;
-- aggregate cost=7.32..7.33 despues de indice y analyze
-- index only scan cost=0.42..7.32

explain select count(*) 
from orders 
where status ='Shipped';
-- aggregate cost=4210.82..4210.83 despues de indice y analyze
-- Gather cost=4210.71..4210.82
-- Partial aggregate cost=3210.71..3210.72
-- Parallel seq cost=0.00..3023.69

select count(*) 
from orders 
where status ='Paid';

select count(*) 
from orders 
where status ='Processed';