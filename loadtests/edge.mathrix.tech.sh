#!/usr/bin/env bash

loadtest -n 1000 -c 10 -m POST \
  -H 'authority: edge.mathrix.tech' \
  -H 'accept: */*' \
  -H 'x-apollo-tracing: 1' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36' \
  -H 'content-type: application/json' \
  -H 'origin: https://edge.mathrix.tech' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-dest: empty' \
  -H 'referer: https://edge.mathrix.tech/graphql' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7' \
  --data '{"operationName":null,"variables":{},"query":"{\n  listDisciplines {\n    name\n  }\n}\n"}' \
  'https://edge.mathrix.tech/graphql' \
