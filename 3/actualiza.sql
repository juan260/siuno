
-- CUSTOMER
-- Queremos que la columna de email no sea NULL y borramos las que no usemos

UPDATE customers SET email = 'default@default.com' WHERE email IS NULL;
ALTER TABLE customers
 ALTER COLUMN email SET NOT NULL,
 DROP COLUMN address2,
 DROP COLUMN state,
 DROP COLUMN region,
 DROP COLUMN phone,
 DROP COLUMN age,
 DROP COLUMN gender;


-- ORDER DETAIL
-- Aniadir clave extranjera para la relacion de ordendetail - product

UPDATE orderdetail SET price= 0 WHERE price IS NULL;

ALTER TABLE orderdetail 
   ADD CONSTRAINT prodid_key
   FOREIGN KEY (prod_id) 
   REFERENCES products(prod_id),
   ADD CONSTRAINT orderid_key
   FOREIGN KEY (orderid) 
   REFERENCES orders(orderid),
   ALTER COLUMN price SET NOT NULL,
   ADD CONSTRAINT ordetail_id
   PRIMARY KEY (orderid, prod_id);

-- Aniadir clave extranjera para relacion de orden - cliente
ALTER TABLE orders 
   ADD CONSTRAINT customerid_key
   FOREIGN KEY (customerid) 
   REFERENCES customers(customerid);