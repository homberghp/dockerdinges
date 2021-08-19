#!/bin/bash

docker run --name prj1_postgres -p 5433:5432 -e POSTGRES_USER=exam -e POSTGRES_PASSWORD=exam -d postgres

