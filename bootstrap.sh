#!/usr/bin/env bash

set -euo pipefail

echo "========================================"
echo " Secure Kubernetes CI/CD Lab Bootstrap"
echo "========================================"
echo

echo "==> Checking required tools..."

REQUIRED_TOOLS=(
    kubectl
    git
    curl
)

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "${tool}" >/dev/null 2>&1; then
        echo "ERROR: Required tool '${tool}' is not installed or not in PATH."
        exit 1
    fi

    echo "  ✔ ${tool}: $(command -v "${tool}")"
done

echo
echo "==> Checking Kubernetes cluster connectivity..."

if ! kubectl cluster-info >/dev/null 2>&1; then
    echo "ERROR: Cannot connect to the Kubernetes cluster."
    exit 1
fi

echo "  ✔ Kubernetes API is reachable."

echo
echo "==> Checking Kubernetes nodes..."

kubectl get nodes

echo
echo "==> Checking Kustomize support..."

if ! kubectl kustomize --help >/dev/null 2>&1; then
    echo "ERROR: kubectl kustomize is not available."
    exit 1
fi

echo "  ✔ Kustomize is available."

echo
echo "========================================"
echo " Environment validation successful"
echo "========================================"