#!/usr/bin/env bash
# Bootstrap HM-OPS01 (Ubuntu 24.04). Idempotent. Run as your user with sudo rights.
set -euo pipefail
TF_VERSION="${TF_VERSION:-1.9.8}"

sudo apt-get update
sudo apt-get install -y git curl unzip jq make gnupg lsb-release ca-certificates python3-pip python3-venv direnv

# HashiCorp repo (terraform)
if ! command -v terraform >/dev/null; then
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt-get update && sudo apt-get install -y terraform="${TF_VERSION}-1"
fi

# Azure CLI
command -v az >/dev/null || curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# GitHub CLI
if ! command -v gh >/dev/null; then
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list
  sudo apt-get update && sudo apt-get install -y gh
fi

# kubectl, helm, kubelogin
command -v kubectl  >/dev/null || sudo az aks install-cli
command -v helm     >/dev/null || curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# python tools
pip3 install --user --break-system-packages pre-commit checkov

# tflint, tfsec, terraform-docs, infracost
command -v tflint  >/dev/null || curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
command -v tfsec   >/dev/null || curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
command -v infracost >/dev/null || curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

# direnv hook
grep -q 'direnv hook bash' ~/.bashrc || echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

echo "Done. Versions:"
terraform version | head -1; az version --query '"azure-cli"' -o tsv; gh --version | head -1; kubectl version --client --short 2>/dev/null || kubectl version --client
