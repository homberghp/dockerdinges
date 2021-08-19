#!/bin/bash
set -e 

cat << EOF | psql -U ${POSTGRES_USER} postgres
drop database if exists presidents;
drop database if exists hotel_california;
create database  presidents;
grant all privileges on database presidents to ${POSTGRES_USER};
EOF

## first example: database  exists, so we can connect to it with psql
zcat president-full.sql.gz | psql -X -U exam presidents

## database hotel_california does not yet exists, but is created with the sql script
## next line intentionally commented out.
###  do not use zcat hotel_california.sql.gz | psql -X -U exam postgres
