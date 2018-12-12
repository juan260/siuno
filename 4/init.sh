#!/bin/bash

export PGPASSWORD='alumnodb';
dropdb -U alumnodb si1
createdb -U alumnodb si1


gunzip -c dump_v1.0-P4.sql.gz | psql -U alumnodb si1

cat clientesDistintosFunc.sql | psql -U alumnodb si1

cat turnOnStats.sql | psql -U alumnodb si1

cat updOrders.sql | psql -U alumnodb si1

cat updPromo.sql | psql -U alumnodb si1

