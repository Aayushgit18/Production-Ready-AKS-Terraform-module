# Production-Ready AKS Infrastructure using Terraform

## 1. Overview

This repository provisions a **production-ready Azure Kubernetes Service (AKS)** platform using **Terraform**, following **modular infrastructure-as-code principles** and **enterprise DevOps best practices**.

It supports **multiple environments (dev & prod)** with a **shared remote Terraform backend**, reusable modules, and secure identity-based access.

---

## 2. Key Features

* Modular Terraform architecture
* Remote backend using Azure Blob Storage
* Separate **dev** and **prod** environments
* Azure CNI networking
* Public AKS cluster (simplified access)
* Azure AD (Entra ID) RBAC
* Azure Container Registry (ACR) integration
* Azure Key Vault (RBAC enabled)
* Centralized monitoring using Log Analytics
* OIDC + AKS Workload Identity enabled
* No secrets stored in Terraform code

---

## 3. Repository Structure

```
.
├── bootstrap/                # One-time backend infrastructure
├── environments/
│   ├── dev/                  # Development environment
│   └── prod/                 # Production environment
├── modules/                  # Reusable Terraform modules
│   ├── aks/                  # AKS cluster and node pools
│   ├── acr/                  # Azure Container Registry
│   ├── network/              # Virtual network and subnets
│   ├── monitoring/           # Log Analytics Workspace
│   ├── key-vault/            # Azure Key Vault (RBAC)
│   └── resource-group/       # Resource Group
├── versions.tf               # Terraform & provider versions
└── README.md
```

---

## 4. Prerequisites

### Required Tools

| Tool      | Version  |
| --------- | -------- |
| Terraform | >= 1.4.0 |
| Azure CLI | Latest   |
| Git       | Latest   |
| kubectl   | Latest   |

Verify:

```bash
terraform -v
az version
kubectl version --client
```

---

### Azure Permissions

The Azure account must have:

* **Contributor** on the subscription
* **User Access Administrator** (required for RBAC role assignments)

---

## 5. Design Decisions (Important)

### Why `subscription_id` exists only in `bootstrap`

The `bootstrap` folder creates the **Terraform remote backend** (storage account + container).

Terraform backends:

* Cannot use variables
* Must use static values

Therefore, the provider inside `bootstrap` explicitly defines:

```hcl
subscription_id = "<subscription-id>"
```

---

### Why dev & prod do not define `subscription_id`

Environment deployments rely on Azure CLI authentication:

```bash
az login
az account set --subscription <subscription-id>
```

Terraform automatically uses the active subscription, enabling:

* Environment portability
* No hardcoded credentials
* Multi-subscription support

---

## 6. Deployment Steps

---

### Step 1 — Bootstrap Terraform Backend (One Time)

```bash
cd bootstrap
terraform init
terraform apply
```

Creates:

* Resource group
* Storage account
* Blob container for Terraform state

---

### Step 2 — Deploy DEV Environment

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

Files to review:

* `backend.tf`
* `terraform.tfvars`

---

### Step 3 — Deploy PROD Environment

```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

Files to review:

* `backend.tf`
* `terraform.tfvars`

---

## 7. AKS Configuration

Terraform creates:

* AKS cluster with Azure AD RBAC
* System node pool (autoscaling)
* User node pool (autoscaling)
* Azure CNI networking
* Azure Policy enabled
* Log Analytics integration
* OIDC issuer for Workload Identity

---

## 8. Azure Key Vault Integration

The platform includes **Azure Key Vault** with:

* RBAC authorization enabled
* Public network access enabled
* No access policies (RBAC-only model)
* Designed for AKS Workload Identity integration

Key Vault is provisioned via:

```
modules/key-vault
```

Terraform **does not store secrets**.

---

## 9. Outputs

After deployment:

```bash
terraform output
```

Available outputs include:

* AKS cluster name
* AKS resource group
* Kubeconfig (sensitive)
* ACR login server
* Key Vault ID and name
* Log Analytics workspace ID
* VNet and subnet IDs
* OIDC issuer URL

---

## 10. Accessing the AKS Cluster

```bash
az aks get-credentials \
  --resource-group aks-dev-rg \
  --name aks-dev
```

Verify:

```bash
kubectl get nodes
```

---

## 11. Security & Best Practices

* Azure AD RBAC enabled
* Managed identities used throughout
* ACR pull access via role assignment
* Separate system and user node pools
* Autoscaling enabled
* Centralized logging
* Centralized secret management (Key Vault)
* No credentials committed to Git

---

## 12. Cleanup

Destroy an environment:

```bash
cd environments/dev
terraform destroy
```

```bash
cd environments/prod
terraform destroy
```
