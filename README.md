
# Production-Ready AKS Infrastructure using Terraform

## 1. Overview

This repository provisions a **production-ready Azure Kubernetes Service (AKS)** infrastructure using **Terraform**, following **enterprise DevOps and security best practices**.

It supports **multiple environments (dev & prod)** with a **shared backend**, modular Terraform design, and secure integrations.

---

## 2. Key Features

* Modular Terraform architecture
* Remote backend with Azure Blob Storage
* Separate **dev** and **prod** environments
* Secure networking with **Azure CNI**
* **Private AKS cluster**
* Azure AD (Entra ID) RBAC
* Azure Container Registry (ACR) integration
* **Azure Key Vault with RBAC**
* Monitoring with Log Analytics
* **Workload Identity (OIDC) enabled**
* No secrets stored in Terraform code

---

## 3. Repository Structure

```
.
├── bootstrap/                # ONE-TIME infra (Terraform backend)
├── environments/
│   ├── dev/                  # Dev environment
│   └── prod/                 # Prod environment
├── modules/                  # Reusable Terraform modules
│   ├── aks/                  # AKS cluster & node pools
│   ├── acr/                  # Azure Container Registry
│   ├── network/              # VNet & subnets
│   ├── monitoring/           # Log Analytics
│   ├── key-vault/            # Azure Key Vault (RBAC)
│   └── resource-group/       # Resource Group
├── versions.tf               # Provider + Terraform version
└── README.md
```

---

## 4. Prerequisites

### Tools Required

| Tool      | Minimum Version |
| --------- | --------------- |
| Terraform | >= 1.4.0        |
| Azure CLI | Latest          |
| Git       | Latest          |
| kubectl   | Latest          |

Verify installation:

```bash
terraform -v
az version
kubectl version --client
```

---

### Azure Permissions Required

The Azure account must have:

* **Contributor** on the subscription
* **User Access Administrator** (required for role assignments like ACR Pull & Key Vault RBAC)

---

## 5. Important Design Decisions (Must Read)

### Why `subscription_id` exists ONLY in `bootstrap`

The `bootstrap` folder creates the **Terraform remote backend** (Storage Account + Blob Container).

Terraform backends:

* ❌ Cannot use variables
* ❌ Cannot depend on environment configuration
* ✅ Must use static values

Therefore:

```hcl
provider "azurerm" {
  subscription_id = "<your-subscription-id>"
}
```

is required **ONLY inside `bootstrap/`**.

---

### Why dev & prod do NOT define `subscription_id`

`environments/dev` and `environments/prod` rely on Azure CLI authentication:

```bash
az login
az account set --subscription <subscription-id>
```

Terraform automatically uses the **active Azure subscription**.

This enables:

* Same code across environments
* No hard-coded secrets
* Easy multi-subscription support

---

## 6. Step-by-Step Deployment Guide

---

### STEP 1 — Create Terraform Backend (ONE TIME ONLY)

Navigate to `bootstrap/`:

```bash
cd bootstrap
terraform init
terraform apply
```

This creates:

* Resource Group
* Storage Account
* Blob Container for Terraform state

⚠️ **Do NOT delete this unless the entire platform is retired.**

---

### STEP 2 — Deploy DEV Environment

Navigate to `environments/dev/`

#### Files you MUST review/edit:

* `backend.tf` → storage account name
* `terraform.tfvars` → resource names, CIDRs, tenant ID

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

---

### STEP 3 — Deploy PROD Environment

Navigate to `environments/prod/`

#### Files you MUST review/edit:

* `backend.tf`
* `terraform.tfvars`

```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

---

## 7. Azure Key Vault Integration

This platform includes **Azure Key Vault** with:

* RBAC authorization enabled
* Public access disabled
* No access policies (RBAC-only model)
* Designed for **AKS Workload Identity**

Key Vault is created via:

```
modules/key-vault
```

It can be used with:

* Secrets Store CSI Driver
* External Secrets
* Secure application configuration

⚠️ **No secrets are stored in Terraform code or state.**

---

## 8. Outputs

After successful deployment:

```bash
terraform output
```

Available outputs include:

* AKS cluster name
* Resource group name
* Kubeconfig (**sensitive**)
* ACR login server
* Key Vault ID & name
* VNet and subnet IDs
* OIDC issuer URL

---

## 9. Accessing the AKS Cluster

```bash
az aks get-credentials \
  --resource-group aks-dev-rg \
  --name aks-dev
```

Verify access:

```bash
kubectl get nodes
```

---

## 10. Security & Production Controls

* Private AKS API server
* Azure AD (Entra ID) RBAC
* Managed identities everywhere
* ACR pull via role assignment
* Separate system & user node pools
* Autoscaling enabled
* Centralized logging (Log Analytics)
* Centralized secrets (Key Vault)
* OIDC Workload Identity enabled
* No credentials committed to Git

---

## 11. Cleanup (Optional)

Destroy environment resources:

```bash
cd environments/dev
terraform destroy
```

```bash
cd environments/prod
terraform destroy
```

⚠️ **Do NOT destroy `bootstrap` unless backend is no longer required.**

