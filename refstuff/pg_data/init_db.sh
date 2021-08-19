#!/bin/bash
set -e 

cat << EOF | psql -U exam postgres
create database  presidents;
grant all privileges on database presidents to exam;
EOF

zcat president-full.sql | psql -X -U exam presidents
