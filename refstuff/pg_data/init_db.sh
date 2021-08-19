#!/bin/bash
set -e 

## use -X flag to turn of any preset in .psqlrc
cat << EOF | psql -X -U exam postgres
drop database if exists presidents;
drop database if exists hotel_california;
create database  presidents;
grant all privileges on database presidents to exam;
create database hotel_california;
grant all privileges on database hotel_california to exam;
EOF

## first example: database  exists, so we can connect to it with psql
zcat president-full.sql.gz | psql -X -U exam presidents
zcat hotel_california.sql.gz | psql -X -U exam hotel_california

