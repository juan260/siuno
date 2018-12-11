explain select count(*) 
from orders 
where status is null;


explain select count(*) 
from orders 
where status ='Shipped';

CREATE INDEX orders_status_index
ON orders(status);

explain select count(*) 
from orders 
where status is null;

explain select count(*) 
from orders 
where status ='Shipped';

ANALYZE orders;

explain select count(*) 
from orders 
where status is null;

explain select count(*) 
from orders 
where status ='Shipped';

explain select count(*) 
from orders 
where status ='Paid';

explain select count(*) 
from orders 
where status ='Processed';