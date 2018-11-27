DROP TRIGGER updInventory ON orders;

CREATE OR REPLACE FUNCTION updOrdersInventory() RETURNS TRIGGER
    as $$
    BEGIN 
	update
		products as PROD
	set
		stock = PROD.stock - orderdetail.quantity,
		sales = PROD.sales + orderdetail.quantity
	from orderdetail
	where orderdetail.orderid = NEW.orderid AND PROD.prod_id = orderdetail.prod_id;

	INSERT INTO alertas (prod_id, description)
		select p.prod_id, 'No hay stock'
		from products as p, orderdetail as od
		where stock = 0 AND p.prod_id=od.prod_id AND od.orderid = NEW.orderid;
	
	RETURN NULL;
    END; 

    $$ LANGUAGE 'plpgsql';



CREATE TRIGGER updInventory
    AFTER UPDATE ON orders
    FOR EACH ROW
    WHEN ( NEW.status = 'Paid')
    EXECUTE PROCEDURE updOrdersInventory();