#!/bin/bash

free -ghw | head -1
time for i in {1001..10000}; do
    CID=$(docker run --runtime runc --name server-$i -d nginx)
    docker exec server-$i /bin/sh -c \
	   "echo I am number $i > /usr/share/nginx/html/index.html"
    free -ghw | grep ^Mem
done

time for i in {1001..10000}; do
    IP=$(docker inspect --format '{{.NetworkSettings.IPAddress}}' server-$i)
    curl -sS http://${IP}/ &
done
