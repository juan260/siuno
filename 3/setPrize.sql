update
	orderdetail as DET
set
	price=PROD.price
from
	products as PROD
where DET.prod_id=PROD.prod_id;
