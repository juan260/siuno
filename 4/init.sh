#!/bin/bash

export PGPASSWORD='alumnodb';
dropdb -U alumnodb si1
createdb -U alumnodb si1


gunzip -c dump_v1.0-P4.sql.gz | psql -U alumnodb si1

#cat dump_v1.0-P4.sql | psql -U alumnodb si1
