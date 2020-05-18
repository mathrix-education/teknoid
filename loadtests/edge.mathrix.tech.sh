#!/usr/bin/env bash
loadtest -n 1000 -c 20 -m GET \
  -H 'authorization: Basic ZWRnZToxMjM0NTY=' \
  -H 'user-agent: LoadTest' \
  'https://edge.mathrix.tech'
