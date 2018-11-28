-- Juan Riera y Luis Cárabe
-- Funcion que crea un carrito para un usuario determinado, el argumento de 
-- entrada es el customerid asociado
CREATE
OR REPLACE FUNCTION createCarrito (integer) RETURNS void as $$ 
BEGIN 
insert into orders -- Crea una nueva fila en orders con los datos correspondientes, tax fijos de 21%
(
  orderdate, customerid, netamount,
  tax, totalamount, status
)
values
  (NOW(), $1, 0, 21, 0, NULL);
END;
$$ LANGUAGE 'plpgsql';
