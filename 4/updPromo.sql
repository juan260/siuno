ALTER TABLE customers
    ADD COLUMN promo integer NOT NULL default 0;

CREATE TRIGGER updPromoTrig 
AFTER
    UPDATE of promo ON customers FOR EACH ROW
    EXECUTE PROCEDURE updPromo();


CREATE
OR REPLACE FUNCTION updPromo () RETURNS TRIGGER as $$ 
BEGIN
update orderdetail 
set price = products.price*(1-NEW.promo/100)
FROM products, orders
WHERE products.prod_id=orderdetail.prod_id
and  orderdetail.orderid = orders.orderdetail
and orders.status IS NULL
and orders.customerid = NEW.customerid;
SELECT pg_sleep(5);
END;
$$ LANGUAGE 'plpgsql';

