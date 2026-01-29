# Production-Ready AKS Infrastructure using Terraform

## 1. Overview

This repository provisions a production-ready Azure Kubernetes Service (AKS) infrastructure using Terraform.

---

## 2. Key Features

* Modular Terraform design
* Remote backend with Azure Blob Storage
* Separate dev and prod environments
* Secure networking with Azure CNI
* Private AKS cluster
* Azure AD (Entra ID) RBAC
* ACR integration
* Monitoring with Log Analytics
* Workload Identity (OIDC)

---

## 3. Repository Structure

```
.
├── bootstrap/                # ONE-TIME infra (Terraform backend)
├── environments/
│   ├── dev/                  # Dev environment
│   └── prod/                 # Prod environment
├── modules/                  # Reusable Terraform modules
│   ├── aks/
│   ├── acr/
│   ├── network/
│   ├── monitoring/
│   └── resource-group/
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
* **User Access Administrator** (required for ACR role assignment)

---

## 5. Important Design Decision (Must Read)

### Why `subscription_id` exists ONLY in `bootstrap`

The `bootstrap` folder creates the **Terraform backend infrastructure** (Storage Account + container).

Terraform backends:

* **Cannot use variables**
* Must be configured with static values

Therefore:

```hcl
provider "azurerm" {
  subscription_id = "<your-subscription-id>"
}
```

is required **ONLY in `bootstrap`**.

---

### Why dev & prod do NOT define `subscription_id`

`environments/dev` and `environments/prod` rely on:

```bash
az login
az account set --subscription <subscription-id>
```

Terraform automatically uses the **currently selected Azure subscription**.

 This allows:

* Same code across subscriptions
* No hard-coded secrets
* Enterprise portability

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
* Blob container for Terraform state

---

### STEP 2 — Deploy DEV Environment

Navigate to `environments/dev/`

#### Files you MUST review/edit:

* `backend.tf` → storage account name
* `terraform.tfvars` → resource names, CIDRs

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

## 7. Outputs

After successful deployment:

```bash
terraform output
```

You will receive:

* AKS cluster name
* Resource group name
* Kubeconfig (sensitive)
* ACR login server
* VNet and subnet IDs
* OIDC issuer URL

---

## 8. Accessing the AKS Cluster

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

## 9. Security & Production Controls

* Private AKS API server
* Azure AD RBAC
* Managed identities
* ACR pull via role assignment
* Separate system & user node pools
* Autoscaling enabled
* Centralized logging (Log Analytics)
* No secrets stored in code

---

## 10. Cleanup (Optional)

Destroy environment resources:

```bash
cd environments/dev
terraform destroy
```

```bash
cd environments/prod
terraform destroy
```

 **Do NOT destroy `bootstrap` unless backend is no longer needed.**

---
