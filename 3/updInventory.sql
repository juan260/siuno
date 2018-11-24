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
	RETURN NULL;
    END; 

    $$ LANGUAGE 'plpgsql';



CREATE TRIGGER updInventory
    AFTER UPDATE ON orders
    FOR EACH ROW
    WHEN ( NEW.status = 'Paid')
    EXECUTE PROCEDURE updOrdersInventory();