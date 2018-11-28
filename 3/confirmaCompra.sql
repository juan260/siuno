-- Juan Riera y Luis Cárabe
-- Funcion que confirma la compra de un usuario los argumentos de entrada son el customerid y el totalAmount del order
CREATE
OR replace FUNCTION confirmacompra (integer, numeric) returns void AS $$ BEGIN
UPDATE
  orders
SET
  status = 'Paid' -- Modificamos el pedido a pagado cuando estemos en el carrito del usuario
WHERE
  customerid = $1
  AND status IS NULL;
UPDATE
  customers -- Modificamos el saldo del usuario
SET
  income = income - $2
WHERE
  customerid = $1;
END;
$$ language 'plpgsql';
