

CREATE OR REPLACE FUNCTION updAddOrders () RETURNS TRIGGER
    as $$
    BEGIN
        
	update
		orders as ORD
	set
		netamount=(ORD.netamount+NEW.price)
	where ORD.orderid=new.orderid and ORD.status=NULL;
    END;
    $$ LANGUAGE 'plpgsql';


CREATE TRIGGER addOrdersTrig
    BEFORE INSERT ON orderdetail
    FOR EACH ROW
    --EXECUTE PROCEDURE checkOrders(NEW.customerid, NEW.orderid);
    EXECUTE PROCEDURE updAddOrders();

CREATE OR REPLACE FUNCTION updSubtractOrders () RETURNS TRIGGER
    as $$
    BEGIN
        
	update
		orders as ORD
	set
		netamount=ORD.netamount-OLD.price
	where ORD.orderid=OLD.orderid and ORD.status=NULL;
    END;
    $$ LANGUAGE 'plpgsql';


CREATE TRIGGER subOrdersTrig
    BEFORE DELETE ON orderdetail
    FOR EACH ROW
    --EXECUTE PROCEDURE checkOrders(NEW.customerid, NEW.orderid);
    EXECUTE PROCEDURE updSubtractOrders();


