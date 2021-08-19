#!/bin/bash
dropdb --if-exists -h 172.17.0.3 -U exam fontys_hotel
createdb -h 172.17.0.3 -U exam -O exam fontys_hotel
cat transdemo.sql  | psql -U exam -h 172.17.0.3 fontys_hotel

