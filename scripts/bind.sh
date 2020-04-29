#!/usr/bin/env bash
read -r -p "Kubernetes namespace: " k8s_ns
read -r -p "Kubernetes service account: " k8s_sa
read -r -p "Google Cloud Service Account email: " gcloud_sa

read -r -d '' COMMAND << CMD
gcloud iam service-accounts add-iam-policy-binding \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:mathrix-education.svc.id.goog[$k8s_ns/$k8s_sa]" \
  "$gcloud_sa"
CMD

read -p "You are going to bind $k8s_ns/$k8s_sa to $gcloud_sa, continue? [Y/n]" -n 1 -r

if [[ $REPLY != "" && ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

eval "$COMMAND"
