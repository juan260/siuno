-- Juan Riera y Luis Cárabe
--DROP TRIGGER updInventory ON orders;
-- Funcion que maneja el stock y las sales de los productos cuando se procesa una compra
CREATE
OR REPLACE FUNCTION updOrdersInventory() RETURNS TRIGGER as $$ BEGIN
update
  products as PROD
set
  stock = PROD.stock - orderdetail.quantity,
  -- Restamos el stock
  sales = PROD.sales + orderdetail.quantity -- Sumamos las sales
from
  orderdetail
where
  orderdetail.orderid = NEW.orderid
  AND PROD.prod_id = orderdetail.prod_id;
INSERT INTO alertas (prod_id, description) -- Creamos nueva alerta
select
  p.prod_id,
  'No hay stock' -- Insertamos el prod id y la descripcion
from
  products as p,
  orderdetail as od
where
  stock = 0
  AND p.prod_id = od.prod_id
  AND od.orderid = NEW.orderid;
-- Cuando el stock se reduzca a 0
RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';
CREATE TRIGGER updInventory
AFTER
UPDATE
  ON orders -- Llamamos a la funcion despues de actualizar orders
  FOR EACH ROW WHEN (NEW.status = 'Paid') -- Cuando el status pase a ser paid
  EXECUTE PROCEDURE updOrdersInventory();
