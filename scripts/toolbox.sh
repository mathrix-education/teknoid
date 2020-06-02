#!/usr/bin/env bash
namespace=services
pod=$(kubectl get pods -n $namespace -l=app.kubernetes.io/name=toolbox -o json | jq -j .items[0].metadata.name)

kubectl exec -n $namespace -it $pod -- ash
