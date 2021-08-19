#!/bin/bash
docker build . -t app_web

docker run --name app_web_$(date -Idate) -v $(pwd)/:/var/www app_web
