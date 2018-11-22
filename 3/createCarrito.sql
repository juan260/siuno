-- Funcion que crea un carrito para un usuario determinado
CREATE OR REPLACE FUNCTION createCarrito (integer) RETURNS void
    as $$
    BEGIN

      insert into orders
        (orderdate, customerid, netamount,
        tax, totalamount, status)
        values (NOW(), $1, 0, 0, 0, NULL);

    END;
    $$ LANGUAGE 'plpgsql';
