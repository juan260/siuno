-- Funcion que recibe como primer argumento un id de un usuario
-- y como segundo argumento un id de un pedido
-- y busca si el usuario tiene otros pedidos en carrito 
-- y los elimina
-- INNECESARIA
CREATE OR REPLACE FUNCTION checkOrders (integer, integer) RETURNS void
	as $$
	declare
	BEGIN
        DELETE FROM orders 
            where orders.customerid=$1 and
                orders.orderid <> $2 and
                orders.status = NULL

    END;    
    $$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION isCarrito (id integer)
    as $$
    BEGIN
        update 
            orders
        set
            totalAmount = orders.totalAmount + 
        where

    END;
    $$ LANGUAGE 'plpgsql';


CREATE OR REPLACE TRIGGER updOrders
    BEFORE INSERT ON orderdetail
    FOR EACH ROW
    WHEN isCarrito(NEW.orderid)
    EXECUTE PROCEDURE checkOrders(NEW.customerid, NEW.orderid);

