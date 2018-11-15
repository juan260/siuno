
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

-- INVENTORY

-- Fusion de inventory y orders

SELECT p.prod_id, movieid, price, description, stock, sales
INTO productsAUX
FROM products p LEFT JOIN inventory i ON p.prod_id = i.prod_id;

DROP TABLE products;

DROP TABLE inventory;

ALTER TABLE productsAUX
RENAME TO products;

ALTER TABLE products
   ADD CONSTRAINT products_pkey
   PRIMARY KEY (prod_id),

   ADD CONSTRAINT products_movieid_fkey
   FOREIGN KEY (movieid) 
   REFERENCES imdb_movies(movieid);


-- ORDER DETAIL
-- Aniadir clave extranjera para la relacion de ordendetail - product

UPDATE orderdetail SET price= 0 WHERE price IS NULL;
UPDATE orderdetail SET quantity= 0 WHERE quantity IS NULL;

SELECT orderid, prod_id, SUM(price) as price , SUM(quantity) as quantity 
INTO orderdetailAUX
FROM orderdetail
GROUP BY (orderid, prod_id);

DROP TABLE orderdetail;

ALTER TABLE orderdetailAUX
RENAME TO orderdetail;

ALTER TABLE orderdetail 
   ADD CONSTRAINT prodid_key
   FOREIGN KEY (prod_id) 
   REFERENCES products(prod_id),

   ADD CONSTRAINT orderid_key
   FOREIGN KEY (orderid) 
   REFERENCES orders(orderid),

   ALTER COLUMN price SET NOT NULL,

   ALTER COLUMN quantity SET NOT NULL,
 
   ADD CONSTRAINT ordetail_id
   PRIMARY KEY (orderid, prod_id);

-- ORDERS

-- Aniadir clave extranjera para relacion de orden - cliente
ALTER TABLE orders 
   ADD CONSTRAINT customerid_key
   FOREIGN KEY (customerid) 
   REFERENCES customers(customerid);

-- ACTORS

ALTER TABLE imdb_actormovies
  ADD CONSTRAINT actoridmov
  FOREIGN KEY (actorid)
  REFERENCES imdb_actors(actorid),

  ADD CONSTRAINT movieidmov
  FOREIGN KEY (movieid)
  REFERENCES imdb_movies(movieid);

-- Create languages
SELECT language
INTO languages
FROM imdb_movielanguages
GROUP BY (language);

ALTER TABLE languages
ADD CONSTRAINT lansid
PRIMARY KEY(language);

ALTER TABLE imdb_movielanguages
ADD CONSTRAINT movieforid
   FOREIGN KEY (language) 
   REFERENCES languages(language);

-- Create countries
SELECT country
INTO countries
FROM imdb_moviecountries
GROUP BY (country);

ALTER TABLE countries
ADD CONSTRAINT coountid
PRIMARY KEY(country);

ALTER TABLE imdb_moviecountries
ADD CONSTRAINT countryforid
   FOREIGN KEY (country) 
   REFERENCES countries(country);

-- Create genres
SELECT genre
INTO genres
FROM imdb_moviegenres
GROUP BY (genre);

ALTER TABLE genres
ADD CONSTRAINT genrid
PRIMARY KEY(genre);

ALTER TABLE imdb_moviegenres
ADD CONSTRAINT genreforid
   FOREIGN KEY (genre) 
   REFERENCES genres(genre);

