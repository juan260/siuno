-- Juan Riera y Luis Cárabe
--DROP TRIGGER addOrdersTrig ON orderdetail;
--DROP TRIGGER subOrdersTrig ON orderdetail;
--DROP TRIGGER updAddOrdersTrig ON orderdetail;
--DROP TRIGGER updSubOrdersTrig ON orderdetail;
-- Funcion que suma el precio nuevo cuando se actualiza un producto a un order aniadiendo mas cantidades
CREATE
OR REPLACE FUNCTION updAddOrders () RETURNS TRIGGER as $$ BEGIN
update
  orders as ORD
set
  netamount = netamount + NEW.price - OLD.price -- se suma el precio
where
  ORD.orderid = NEW.orderid
  and ORD.status IS NULL;
RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';
-- Funcion que suma el precio nuevo cuando se aniade un producto a un order
CREATE
OR REPLACE FUNCTION AddOrders () RETURNS TRIGGER as $$ BEGIN
update
  orders as ORD
set
  netamount = netamount + NEW.price -- se suma el precio
where
  ORD.orderid = NEW.orderid
  and ORD.status IS NULL;
RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';
-- Trigger para cuando se inserte en orderdetail
CREATE TRIGGER addOrdersTrig
AFTER
  INSERT ON orderdetail FOR EACH ROW -- Llamamos a la funcion addOrders
  EXECUTE PROCEDURE AddOrders();
-- Funcion que resta el precio cuando se elimina o se quitan cantidades de un producto
CREATE
OR REPLACE FUNCTION updSubtractOrders () RETURNS TRIGGER as $$ BEGIN
update
  orders as ORD
set
  netamount = ORD.netamount - OLD.price -- Restamos el precio
where
  ORD.orderid = OLD.orderid
  and ORD.status IS NULL;
RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';
-- Trigger para cuando se elimine en orderdetail
CREATE TRIGGER subOrdersTrig
AFTER
  DELETE ON orderdetail FOR EACH ROW EXECUTE PROCEDURE updSubtractOrders();
-- Trigger para cuando se actualice orderdetail aniadiendo nuevas cantidades
CREATE TRIGGER updAddOrdersTrig
AFTER
UPDATE
  ON orderdetail FOR EACH ROW WHEN (OLD.quantity < NEW.quantity) EXECUTE PROCEDURE updAddOrders();
-- Trigger para cuando se actualice orderdetail quitando cantidades
CREATE TRIGGER updSubOrdersTrig
AFTER
UPDATE
  ON orderdetail FOR EACH ROW WHEN (OLD.quantity > NEW.quantity) EXECUTE PROCEDURE updSubtractOrders();
