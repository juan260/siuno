-- Juan Riera y Luis Cárabe
-- CUSTOMERS
-- Queremos que la columna de email no sea NULL y borramos las que
-- no usemos, por otro lado aniadimos algunos defaults a campos
-- obligatorios en nuestro formulario, pero no en el script de poblacion
UPDATE
  customers
SET
  email = 'default@default.com'
WHERE
  email IS NULL;
ALTER TABLE
  customers ALTER COLUMN email
SET
  not NULL,
  ALTER COLUMN income type numeric,
  ALTER COLUMN income
set
  DEFAULT 0,
DROP
  COLUMN address2,
DROP
  COLUMN state,
DROP
  COLUMN region,
DROP
  COLUMN phone,
DROP
  COLUMN age,
DROP
  COLUMN gender;
-- INVENTORY
-- Fusion de inventory y products
SELECT
  p.prod_id,
  movieid,
  price,
  description,
  stock,
  sales INTO productsaux
FROM
  products p
  LEFT JOIN inventory i ON p.prod_id = i.prod_id;
DROP
  TABLE products;
DROP
  TABLE inventory;
ALTER TABLE
  productsaux rename TO products;
-- Aniadimos primary key y foreign key
ALTER TABLE
  products
ADD
  CONSTRAINT products_pkey PRIMARY KEY (prod_id),
add
  CONSTRAINT products_movieid_fkey FOREIGN KEY (movieid) REFERENCES imdb_movies(movieid);
-- Hacemos que prod_id aumente en 1 por cada fila nueva automaticamente
--
-- Name: products_prod_id_seq; Type: SEQUENCE; Schema: public; Owner: alumnodb
--
CREATE sequence PUBLIC.products_prod_id_seq start WITH 1 increment BY 1 no minvalue no maxvalue cache 1;
ALTER TABLE
  PUBLIC.products_prod_id_seq owner TO alumnodb;
--
-- Name: products_prod_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alumnodb
--
ALTER sequence PUBLIC.products_prod_id_seq owned BY PUBLIC.products.prod_id;
ALTER TABLE
  only PUBLIC.products ALTER COLUMN prod_id
SET
  DEFAULT nextval(
    'public.products_prod_id_seq' :: regclass
  );
-- ORDER DETAIL
-- Ponemos todas las cantidades y precios a 0 cuando sean NULL
UPDATE
  orderdetail
SET
  price = 0
WHERE
  price IS NULL;
UPDATE
  orderdetail
SET
  quantity = 0
WHERE
  quantity IS NULL;
-- Preparamos la tabla orderdetail para que nuestra futura clave primaria (orderid, prod_id) no tenga productos repetidos
SELECT
  orderid,
  prod_id,
  Sum(price) AS price,
  Sum(quantity) AS quantity -- sumamos precios y cantidades
  INTO orderdetailaux
FROM
  orderdetail
GROUP BY
  (orderid, prod_id);
DROP
  TABLE orderdetail;
ALTER TABLE
  orderdetailaux rename TO orderdetail;
-- Aniadir clave extranjera para la relacion de ordendetail - product/order
ALTER TABLE
  orderdetail
ADD
  CONSTRAINT prodid_key FOREIGN KEY (prod_id) REFERENCES products(prod_id),
add
  CONSTRAINT orderid_key FOREIGN KEY (orderid) REFERENCES orders(orderid),
  ALTER COLUMN price
SET
  not NULL,
  -- price no puede ser null
  ALTER COLUMN quantity
SET
  not NULL,
  --quantity no puede ser null
ADD
  CONSTRAINT ordetail_id -- aniadimos clave primaria formada por orderid y prod_id
  PRIMARY KEY (orderid, prod_id);
-- ORDERS
-- Aniadir clave extranjera para relacion de orden - cliente
ALTER TABLE
  orders
ADD
  CONSTRAINT customerid_key FOREIGN KEY (customerid) REFERENCES customers(customerid);
-- Cuando netamount sea NULL, lo ponemos a 0
UPDATE
  orders
SET
  netamount = 0
WHERE
  netamount IS NULL;
-- ACTORS
-- Creamos las claves extranjeras de actor y movie en actormovies
ALTER TABLE
  imdb_actormovies
ADD
  CONSTRAINT actoridmov FOREIGN KEY (actorid) REFERENCES imdb_actors(actorid),
add
  CONSTRAINT movieidmov FOREIGN KEY (movieid) REFERENCES imdb_movies(movieid);
-- Creamos la tabla languages listando todos los lenguajes registrados
SELECT
  language INTO languages
FROM
  imdb_movielanguages
GROUP BY
  (language);
-- Aniadimos clave primaria
ALTER TABLE
  languages
ADD
  CONSTRAINT lansid PRIMARY KEY(language);
-- Moficamos movielanguages con las claves foraneas referenciando a la tabla languages
ALTER TABLE
  imdb_movielanguages
ADD
  CONSTRAINT movieforid FOREIGN KEY (language) REFERENCES languages(language);
-- Creamos la tabla countries listando todos los paises registrados
SELECT
  country INTO countries
FROM
  imdb_moviecountries
GROUP BY
  (country);
-- Aniadimos clave primaria
ALTER TABLE
  countries
ADD
  CONSTRAINT coountid PRIMARY KEY(country);
-- Moficamos moviecountries con las claves foraneas referenciando a la tabla countries
ALTER TABLE
  imdb_moviecountries
ADD
  CONSTRAINT countryforid FOREIGN KEY (country) REFERENCES countries(country);
-- Creamos la tabla genres listando todos los generos registrados
SELECT
  genre INTO genres
FROM
  imdb_moviegenres
GROUP BY
  (genre);
-- Aniadimos clave primaria
ALTER TABLE
  genres
ADD
  CONSTRAINT genrid PRIMARY KEY(genre);
-- Moficamos moviegenres con las claves foraneas referenciando a la tabla genres
ALTER TABLE
  imdb_moviegenres
ADD
  CONSTRAINT genreforid FOREIGN KEY (genre) REFERENCES genres(genre);
-- Crear tabla alertas
CREATE TABLE alertas (
  alertaid INTEGER NOT NULL,
  prod_id INTEGER NOT NULL,
  description CHARACTER VARYING(255)
);
-- Hacemos que la clave primaria alertaid se incremente por defecto por cada fila insertada en la tabla
--
-- Name: alertas_alertaid_seq; Type: SEQUENCE; Schema: public; Owner: alumnodb
--
CREATE sequence PUBLIC.alertas_alertaid_seq start WITH 1 increment BY 1 no minvalue no maxvalue cache 1;
ALTER TABLE
  PUBLIC.alertas_alertaid_seq owner TO alumnodb;
--
-- Name: alertas_alertaid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alumnodb
--
ALTER sequence PUBLIC.alertas_alertaid_seq owned BY PUBLIC.alertas.alertaid;
ALTER TABLE
  only PUBLIC.alertas ALTER COLUMN alertaid
SET
  DEFAULT nextval(
    'public.alertas_alertaid_seq' :: regclass
  );
-- Aniadimos la clave primaria y la foranea
ALTER TABLE
  alertas
ADD
  CONSTRAINT alertaprodcons FOREIGN KEY (prod_id) REFERENCES products(prod_id),
add
  CONSTRAINT alertaid PRIMARY KEY (alertaid);
-- Aniadimos sinopsis y poster a la tabla movies
ALTER TABLE
  imdb_movies
ADD
  COLUMN poster varchar(100) NULL,
ADD
  COLUMN sinopsis varchar(250) NULL;
-- Reajustamos todas las secuencias, ya que en el script
-- de poblacion, como se aniadian indicando el identificador,
-- y como ademas algunas secuencias se creaban mas tarde
-- que propios campos, las secuencias no aumentaban
-- correctamente siempre
BEGIN;
SELECT
  Setval(
    'customers_customerid_seq',
    COALESCE(
      (
        SELECT
          Max(customerid) + 1
        FROM
          customers
      ),
      1
    ),
    false
  );
SELECT
  Setval(
    'imdb_actors_actorid_seq',
    COALESCE(
      (
        SELECT
          Max(actorid) + 1
        FROM
          imdb_actors
      ),
      1
    ),
    false
  );
SELECT
  Setval(
    'imdb_directormovies_directorid_seq',
    COALESCE(
      (
        SELECT
          Max(directorid) + 1
        FROM
          imdb_directormovies
      ),
      1
    ),
    false
  );
SELECT
  Setval(
    'imdb_directormovies_movieid_seq',
    COALESCE(
      (
        SELECT
          Max(movieid) + 1
        FROM
          imdb_directormovies
      ),
      1
    ),
    false
  );
SELECT
  Setval(
    'imdb_directors_directorid_seq',
    COALESCE(
      (
        SELECT
          Max(directorid) + 1
        FROM
          imdb_directors
      ),
      1
    ),
    false
  );
SELECT
  Setval(
    'imdb_moviecountries_movieid_seq',
    COALESCE(
      (
        SELECT
          Max(movieid) + 1
        FROM
          imdb_moviecountries
      ),
      1
    ),
    false
  );
SELECT
  Setval(
    'imdb_moviegenres_movieid_seq',
    COALESCE(
      (
        SELECT
          Max(movieid) + 1
        FROM
          imdb_moviegenres
      ),
      1
    ),
    false
  );
SELECT
  Setval(
    'imdb_movies_movieid_seq',
    COALESCE(
      (
        SELECT
          Max(movieid) + 1
        FROM
          imdb_movies
      ),
      1
    ),
    false
  );
SELECT
  Setval(
    'orders_orderid_seq',
    COALESCE(
      (
        SELECT
          Max(orderid) + 1
        FROM
          orders
      ),
      1
    ),
    false
  );
SELECT
  Setval(
    'alertas_alertaid_seq',
    COALESCE(
      (
        SELECT
          Max(alertaid) + 1
        FROM
          alertas
      ),
      1
    ),
    false
  );
SELECT
  Setval(
    'products_prod_id_seq',
    COALESCE(
      (
        SELECT
          Max(prod_id) + 1
        FROM
          products
      ),
      1
    ),
    false
  );
COMMIT;
