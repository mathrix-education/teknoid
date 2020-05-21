#!/usr/bin/env bash
function usage() {
  echo "Usage: ./scripts/apply.sh [application] [overlay]"
}

function apply() {
  APP=$1
  # Workaround for some secrets which seems to not be read by kubectl
  kubectl apply -f "/tmp/$APP.yaml" --prune -l "app.kubernetes.io/part-of=$APP"
  kubectl apply -f "/tmp/$APP.yaml"
  rm /tmp/$APP.yaml
}

function single() {
  APP=$1
  echo "Updating $APP"
  kustomize build src/$APP/ >/tmp/$APP.yaml
  apply "$APP"
}

function multi() {
  APP=$1
  ENV=${2:-all}

  if [ $ENV == 'all' ]; then
    single "$APP"
  else
    echo "Updating $APP ($ENV environment)"
    kustomize build src/$APP/overlays/$ENV/ >/tmp/$APP.yaml
    apply "$APP"
  fi
}

case $1 in
-h) usage ;;
--help) usage ;;

education-angular-v7) multi "education-angular-v7" "${2:-all}" ;;
mysql) single "mysql" ;;
nginx-ingress) single "nginx-ingress" ;;
grafana) single "grafana" ;;
grimoire) single "grimoire" ;;
prometheus) single "prometheus" ;;
railgun) multi "railgun" "${2:-all}" ;;
redis) single "redis" ;;
toolbox) single "toolbox" ;;

*)
  usage
  echo "No apply recipe for application \"$1\""
  exit 1
  ;;
esac
