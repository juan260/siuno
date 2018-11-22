-- Funcion que confirma la compra de un usuario
CREATE OR REPLACE FUNCTION confirmaCompra (integer) RETURNS void
    as $$
    BEGIN

      update
        orders
      set
        status = 'Paid',
        totalamount=netamount + tax
      where customerid = $1;

    END;
    $$ LANGUAGE 'plpgsql';
