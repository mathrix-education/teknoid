#!/usr/bin/env bash
function usage() {
  echo "Usage: ./scripts/apply.sh [application] [overlay]"
}

function single() {
  APP=$1
  echo "Updating $APP"
  kustomize build src/$APP/ >/tmp/$APP.yaml
  kubectl apply -f "/tmp/$APP.yaml" --prune -l "app.kubernetes.io/part-of=$APP"
  kubectl apply -f "/tmp/$APP.yaml"
  rm /tmp/$APP.yaml
}

function multi() {
  APP=$1
  ENV=${2:-all}

  if [ $ENV == 'all' ]; then
    single "$APP"
  else
    echo "Updating $APP ($ENV environment)"
    kustomize build src/$APP/overlays/$ENV/ >/tmp/railgun.yaml

    # Workaround for some secrets which seems to not be read by kubectl
    kubectl apply -f /tmp/railgun.yaml --prune -l "app.kubernetes.io/part-of=$APP"
    kubectl apply -f /tmp/railgun.yaml
    rm /tmp/railgun.yaml
  fi
}

case $1 in
-h) usage ;;
--help) usage ;;

mysql) single "mysql" ;;
grafana) single "grafana" ;;
prometheus) single "prometheus" ;;
railgun) multi "railgun" "${2:-all}" ;;
redis) single "redis" ;;

*)
  usage
  echo "No apply recipe for application \"$1\""
  exit 1
  ;;
esac
