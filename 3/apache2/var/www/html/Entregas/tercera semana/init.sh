#!/bin/bash
dropdb -U alumnodb si1
createdb -U alumnodb si1

gunzip -c dump_v1.2.sql.gz | psql -U alumnodb si1

#cat dump_v1.2.sql | psql -U alumnodb si1

cat actualiza.sql | psql -U alumnodb si1
