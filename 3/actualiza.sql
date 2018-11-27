
-- CUSTOMERS
-- Queremos que la columna de email no sea NULL y borramos las que 
-- no usemos, por otro lado aniadimos algunos defaults a campos 
-- obligatorios en nuestro formulario, pero no en el script de poblacion

UPDATE customers SET email = 'default@default.com' WHERE email IS NULL;
ALTER TABLE customers
 ALTER COLUMN email SET NOT NULL,
 ALTER COLUMN income TYPE numeric,
 ALTER COLUMN income SET DEFAULT 0,
 DROP COLUMN address2,
 DROP COLUMN state,
 DROP COLUMN region,
 DROP COLUMN phone,
 DROP COLUMN age,
 DROP COLUMN gender;

-- INVENTORY

-- Fusion de inventory y products

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

  --
-- Name: products_prod_id_seq; Type: SEQUENCE; Schema: public; Owner: alumnodb
--

CREATE SEQUENCE public.products_prod_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_prod_id_seq OWNER TO alumnodb;

--
-- Name: products_prod_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alumnodb
--

ALTER SEQUENCE public.products_prod_id_seq OWNED BY public.products.prod_id;

ALTER TABLE ONLY public.products ALTER COLUMN prod_id SET DEFAULT nextval('public.products_prod_id_seq'::regclass);


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

update orders
set netamount = 0 
where netamount is null;

-- ACTORS

ALTER TABLE imdb_actormovies
  ADD CONSTRAINT actoridmov
  FOREIGN KEY (actorid)
  REFERENCES imdb_actors(actorid),

  ADD CONSTRAINT movieidmov
  FOREIGN KEY (movieid)
  REFERENCES imdb_movies(movieid);

--ALTER TABLE imdb_actors
 -- ADD COLUMN poster VARCHAR(100) NULL;

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

-- Crear tabla alertas

CREATE TABLE alertas(
  alertaid integer NOT NULL,
  prod_id integer NOT NULL,
  description character varying(255));

  --
-- Name: alertas_alertaid_seq; Type: SEQUENCE; Schema: public; Owner: alumnodb
--

CREATE SEQUENCE public.alertas_alertaid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alertas_alertaid_seq OWNER TO alumnodb;

--
-- Name: alertas_alertaid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alumnodb
--

ALTER SEQUENCE public.alertas_alertaid_seq OWNED BY public.alertas.alertaid;

ALTER TABLE ONLY public.alertas ALTER COLUMN alertaid SET DEFAULT nextval('public.alertas_alertaid_seq'::regclass);



ALTER TABLE alertas
  ADD CONSTRAINT alertaprodcons
  FOREIGN KEY (prod_id) 
  REFERENCES products(prod_id),

  ADD CONSTRAINT alertaid
  PRIMARY KEY (alertaid);

ALTER TABLE imdb_movies
   ADD COLUMN poster VARCHAR(100) NULL,
   ADD COLUMN sinopsis VARCHAR(250) NULL;

BEGIN;
SELECT setval('customers_customerid_seq', COALESCE((SELECT MAX(customerid)+1 FROM customers), 1), false);

SELECT setval('imdb_actors_actorid_seq', 
   COALESCE((SELECT MAX(actorid)+1 FROM imdb_actors), 1), false);

SELECT setval('imdb_directormovies_directorid_seq', 
   COALESCE((SELECT MAX(directorid)+1 FROM imdb_directormovies), 1), false);

SELECT setval('imdb_directormovies_movieid_seq', 
   COALESCE((SELECT MAX(movieid)+1 FROM imdb_directormovies), 1), false);

SELECT setval('imdb_directors_directorid_seq', 
   COALESCE((SELECT MAX(directorid)+1 FROM imdb_directors), 1), false);

SELECT setval('imdb_moviecountries_movieid_seq', 
   COALESCE((SELECT MAX(movieid)+1 FROM imdb_moviecountries), 1), false);

SELECT setval('imdb_moviegenres_movieid_seq', 
   COALESCE((SELECT MAX(movieid)+1 FROM imdb_moviegenres), 1), false);

SELECT setval('imdb_movies_movieid_seq', 
   COALESCE((SELECT MAX(movieid)+1 FROM imdb_movies), 1), false);

SELECT setval('orders_orderid_seq', 
   COALESCE((SELECT MAX(orderid)+1 FROM orders), 1), false);

SELECT setval('alertas_alertaid_seq', 
   COALESCE((SELECT MAX(alertaid)+1 FROM alertas), 1), false);

SELECT setval('products_prod_id_seq', 
   COALESCE((SELECT MAX(prod_id)+1 FROM products), 1), false);


COMMIT;
