#!/usr/bin/env bash
loadtest -n 1000 -c 20 -m POST \
  -H 'user-agent: LoadTest' \
  -H 'content-type: application/json' \
  --data '{"operationName":null,"variables":{},"query":"{\nlistDisciplines{\nname\n}\n}\n"}' \
  'https://edge.mathrix.tech/graphql'
