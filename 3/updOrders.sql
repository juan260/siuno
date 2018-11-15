-- Funcion que recibe como primer argumento un id de un usuario
-- y como segundo argumento un id de un pedido
-- y busca si el usuario tiene otros pedidos en carrito 
-- y los elimina
-- INNECESARIA
--CREATE OR REPLACE FUNCTION checkOrders (integer, integer) RETURNS void
--	as $$
--	declare
--	BEGIN
  --      DELETE FROM orders 
    --        where orders.customerid=$1 and
      --          orders.orderid <> $2 and
       --         orders.status = NULL
--
  --  END;    
   -- $$ LANGUAGE 'plpgsql';


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
    BEFORE INSERT ON orderdetail
    FOR EACH ROW
    --EXECUTE PROCEDURE checkOrders(NEW.customerid, NEW.orderid);
    EXECUTE PROCEDURE updSubtractOrders();


