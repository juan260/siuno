-- Queremos que la columna de email de customer no sea NULL

-- Deberiamos quitar algunos not NULL? pej en country

--UPDATE customers SET email="default@default.com" WHERE email IS NULL;
--ALTER TABLE customers
 --ALTER COLUMN email character varying(50) NOT NULL;

-- Aniadir clave extranjera para la relacion de ordendetail - product
ALTER TABLE orderdetail 
   ADD CONSTRAINT prodid_key
   FOREIGN KEY (prod_id) 
   REFERENCES products(prod_id);

-- Aniadir clave extranjera para relacion de orden - cliente
ALTER TABLE orders 
   ADD CONSTRAINT customerid_key
   FOREIGN KEY (customerid) 
   REFERENCES customers(customerid);