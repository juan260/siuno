#!/bin/bash

export PGPASSWORD='alumnodb';
dropdb -U alumnodb si1
createdb -U alumnodb si1


gunzip -c dump_v1.2.sql.gz | psql -U alumnodb si1

#cat dump_v1.2.sql | psql -U alumnodb si1

cat actualiza.sql | psql -U alumnodb si1

cat setOrderAmount.sql | psql -U alumnodb si1

cat setPrize.sql | psql -U alumnodb si1

cat updInventory.sql | psql -U alumnodb si1

cat updOrders.sql | psql -U alumnodb si1

cat getTopMonths.sql | psql -U alumnodb si1

cat getTopVentas.sql | psql -U alumnodb si1

cat createCarrito.sql | psql -U alumnodb si1

echo 'select setOrderAmount();' | psql -U alumnodb si1
