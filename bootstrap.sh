#!/usr/bin/env bash

set -euo pipefail

NAMESPACE="dev"
K8S_DIR="k8s"
DEPLOYMENT="secure-kubernetes-cicd"

echo "==> Checking required tools..."

command -v kubectl >/dev/null 2>&1 || {
    echo "ERROR: kubectl is not installed or not in PATH."
    exit 1
}

echo "==> Checking Kubernetes cluster connectivity..."

kubectl cluster-info >/dev/null 2>&1 || {
    echo "ERROR: Cannot connect to the Kubernetes cluster."
    exit 1
}

echo "==> Creating namespace: ${NAMESPACE}"

kubectl create namespace "${NAMESPACE}" \
    --dry-run=client \
    -o yaml | kubectl apply -f -

echo "==> Validating Kubernetes manifests..."

kubectl apply \
    --dry-run=client \
    -f "${K8S_DIR}/deployment.yaml"

kubectl apply \
    --dry-run=client \
    -f "${K8S_DIR}/service.yaml"

echo "==> Applying Kubernetes manifests..."

kubectl apply -f "${K8S_DIR}/deployment.yaml"
kubectl apply -f "${K8S_DIR}/service.yaml"

echo "==> Waiting for deployment rollout..."

kubectl rollout status \
    "deployment/${DEPLOYMENT}" \
    -n "${NAMESPACE}" \
    --timeout=120s

echo
echo "==> Kubernetes environment is ready."
echo

echo "Pods:"
kubectl get pods -n "${NAMESPACE}"

echo
echo "Service:"
kubectl get service -n "${NAMESPACE}"