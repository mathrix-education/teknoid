#!/bin/bash
docker run --rm -t -a stdout -v $PWD/nginx.conf:/etc/nginx/nginx.conf:ro nginx:alpine nginx -c /etc/nginx/nginx.conf -t
