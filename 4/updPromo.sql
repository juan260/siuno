ALTER TABLE customers
    ADD COLUMN promo integer NOT NULL default 0;

CREATE TRIGGER updPromoTrig 
AFTER
    UPDATE ON customers FOR EACH ROW
    WHEN OLD.promo != NEW.promo
    EXECUTE PROCEDURE updPromo();

CREATE
OR REPLACE FUNCTION updPromo () RETURNS TRIGGER as $$ 
declare 

BEGIN
update orderdetail 
set orderdetail.price = products.price*(NEW.promo/100)
FROM products
WHERE products.prod_id=orderdetail.prod_id
END;
$$ LANGUAGE 'plpgsql';