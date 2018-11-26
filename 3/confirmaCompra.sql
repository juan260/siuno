-- Funcion que confirma la compra de un usuario TODO
CREATE OR REPLACE FUNCTION confirmaCompra (integer, integer) RETURNS void
    as $$
    BEGIN

      update
        orders
      set
        status = 'Paid'
      where customerid = $1 and status is NULL;

      update
        customers
      set
       income = income - $2
      where customerid = $1;

    END;
    $$ LANGUAGE 'plpgsql';
