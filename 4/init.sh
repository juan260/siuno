#!/bin/bash

export PGPASSWORD='alumnodb';
dropdb -U alumnodb si1
createdb -U alumnodb si1


gunzip -c dump_v1.0-P4.sql.gz | psql -U alumnodb si1

<<<<<<< HEAD
cat clientesDistintosFunc.sql | psql -U alumnodb si1

cat turnOnStats.sql | psql -U alumnodb si1
=======
#cat clientesDistintosFunc.sql | psql -U alumnodb si1
>>>>>>> 5a53e9eac026da2e239c78650a6e252fa1f09c5b
