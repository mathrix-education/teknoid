#!/usr/bin/env bash
loadtest -n 1000 -c 8 \
  -m POST \
  --data '{"operationName":null,"variables":{},"query":"{\n  listDisciplines {\n    name\n  }\n}\n"}' \
  "https://edge.mathrix.tech/graphql"
