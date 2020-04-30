#!/usr/bin/env bash
function usage() {
  echo "Usage: ./scripts/apply.sh [application] [overlay]"
}

function single() {
  APP=$1
  echo "Updating $APP"
  kustomize build src/$APP/ > /tmp/$APP.yaml
  kubectl apply -f /tmp/$APP.yaml --prune -l "app.kubernetes.io/part-of=$APP"
  kubectl apply -f /tmp/$APP.yaml
}

function railgun() {
  ENV=${1:-edge}
  echo "Updating Railgun ($1 environment)"
  kustomize build src/railgun/overlays/$ENV/ >/tmp/railgun.yaml
  # Workaround for some secrets which seems to not be read by kubectl
  kubectl apply -f /tmp/railgun.yaml --prune -l "app.kubernetes.io/part-of=railgun"
  kubectl apply -f /tmp/railgun.yaml
  rm /tmp/railgun.yaml
}

case $1 in
-h) usage ;;
--help) usage ;;

mysql) single "mysql" ;;
grafana) single "grafana" ;;
prometheus) single "prometheus" ;;
railgun) railgun "${2:-edge}" ;;
redis) single "redis" ;;

*)
  usage
  echo "No apply recipe for application \"$1\""
  exit 1
  ;;
esac
