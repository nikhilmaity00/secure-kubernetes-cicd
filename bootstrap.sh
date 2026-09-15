#!/usr/bin/env bash

set -euo pipefail

GITOPS_REPO="https://github.com/nikhilmaity00/secure-kubernetes-cicd-gitops.git"
GITOPS_DIR="${HOME}/secure-kubernetes-cicd-gitops"

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

clone_or_update_repo() {
    local repo_url="$1"
    local repo_dir="$2"

    if [[ -d "${repo_dir}/.git" ]]; then
        echo "==> Updating repository: ${repo_dir}"

        git -C "${repo_dir}" fetch origin
        git -C "${repo_dir}" checkout main
        git -C "${repo_dir}" reset --hard origin/main
    else
        echo "==> Cloning repository: ${repo_url}"

        mkdir -p "$(dirname "${repo_dir}")"
        git clone "${repo_url}" "${repo_dir}"
    fi
}

echo
echo "==> Preparing GitOps repository..."

clone_or_update_repo "${GITOPS_REPO}" "${GITOPS_DIR}"

echo
echo "========================================"
echo " Repository setup successful"
echo "========================================"