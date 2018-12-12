ALTER TABLE customers
    ADD COLUMN promo integer NOT NULL default 0;


CREATE
OR REPLACE FUNCTION updPromo () RETURNS TRIGGER as $$ 
BEGIN
    update orderdetail 
    set price = products.price*orderdetail.quantity*(1-cast(NEW.promo as numeric)/cast(100 as numeric))
    FROM products, orders
    WHERE products.prod_id=orderdetail.prod_id
    and  orderdetail.orderid = orders.orderid
    and orders.status IS NULL
    and orders.customerid = NEW.customerid;

    PERFORM pg_sleep(1);
    RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER updPromoTrig 
AFTER
    UPDATE of promo ON customers FOR EACH ROW
    EXECUTE PROCEDURE updPromo();

