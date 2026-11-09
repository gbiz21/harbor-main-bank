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
if ! command -v tflint >/dev/null; then
  # pinned release download instead of curl | bash; the install script URL has 404'd before
  url=$(curl -fsSL https://api.github.com/repos/terraform-linters/tflint/releases/latest | jq -r '.assets[] | select(.name=="tflint_linux_amd64.zip") | .browser_download_url')
  curl -fsSL "$url" -o /tmp/tflint.zip && sudo unzip -oq /tmp/tflint.zip -d /usr/local/bin && sudo chmod 755 /usr/local/bin/tflint
fi
if ! command -v trivy >/dev/null; then
  # tfsec is archived; Trivy is its successor and covers Terraform misconfig scanning
  curl -fsSL https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor -o /usr/share/keyrings/trivy.gpg
  echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee /etc/apt/sources.list.d/trivy.list >/dev/null
  sudo apt-get update && sudo apt-get install -y trivy
fi
command -v infracost >/dev/null || curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

# direnv hook
grep -q 'direnv hook bash' ~/.bashrc || echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
grep -q 'HOME/.local/bin' ~/.bashrc || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

echo "Done. Versions:"
export PATH="$HOME/.local/bin:$PATH"
terraform version | head -1; az version --query '"azure-cli"' -o tsv; gh --version | head -1; kubectl version --client 2>/dev/null | head -1; helm version --short; tflint --version | head -1; trivy --version | head -1; infracost --version; pre-commit --version; checkov --version
