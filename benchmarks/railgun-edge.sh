#!/usr/bin/env bash
ab -n 1000 -c 2 -s 10 "https://edge.mathrix.tech/graphql/healthz?checks=database,redis"
