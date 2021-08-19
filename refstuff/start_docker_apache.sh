#!/bin/bash
docker run --name prj1_apache -p 8080:80 -v $(pwd):/var/www --link prj1_postgres -d socke77/prj1_apache
