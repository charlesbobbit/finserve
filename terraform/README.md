# Infrastructure as Code

Terraform configuration for the FinServe DevSecOps. The infrastructure is modular, supports multiple environments, and follows Azure best practices.

## Architecture

```mermaid
graph TB
    subgraph "Resource Group"
        A[rg-finserve-{env}]
    end
    
    subgraph "Virtual Network"
        B[vnet-finserve-{env}]
        C[10.0.0.0/16]
        B --> C
    end
    
    subgraph "Subnets"
        D[AKS Subnet<br/>10.0.1.0/24]
        E[VM Subnet<br/>10.0.2.0/24]
        B --> D
        B --> E
    end
    
    subgraph "AKS Cluster"
        F[aks-finserve-{env}]
        G[Node Pool<br/>Standard_D2s_v3]
        D --> F
        F --> G
    end
    
    subgraph "Linux VM"
        H[vm-finserve-{env}]
        I[Standard_B1s]
        J[SSH Access]
        E --> H
        H --> I
        H --> J
    end
    
    subgraph "Security"
        K[NSG - VM]
        L[SSH Rule<br/>Port 22]
        E --> K
        K --> L
    end
    
    A --> B
    A --> F
    A --> H
    A --> K
```

## Module Structure

Three main modules handle different aspects of the infrastructure:

### Network Module (`modules/network/`)
Creates the virtual network, subnets, and security groups. Uses 10.0.0.0/16 address space with separate subnets for AKS (10.0.1.0/24) and VM (10.0.2.0/24). SSH access is open for demo purposes.

### AKS Module (`modules/aks/`)
Deploys the Kubernetes cluster with RBAC enabled. Uses Standard_D2s_v3 instances in a single node pool to balance performance and cost.

### VM Module (`modules/vm/`)
Standalone Ubuntu VM (Standard_B1s) with SSH key authentication. Needed for external access and monitoring.

## Multi-Environment Support

Uses Terraform workspaces and environment-specific variable files:

```bash
terraform workspace select staging
terraform plan -var-file="environments/staging/terraform.tfvars"
```

Resources are named with environment prefixes: `rg-finserve-{environment}`, `vnet-finserve-{environment}`, etc.

## State Management

Uses local state storage (remote backend configuration deferred for the assessment scope). In production, you'd configure Azure Storage backend.

## Deployment

```bash
terraform init
terraform workspace select staging
terraform plan -var-file="environments/staging/terraform.tfvars"
terraform apply -var-file="environments/staging/terraform.tfvars"
```

## Key Outputs
- `aks_cluster_name` - AKS cluster name
- `aks_kubeconfig` - Kubeconfig for cluster access
- `vm_public_ip` - VM public IP
- `resource_group_name` - Resource group name

## Engineering Notes

- **Local state** - Remote backend deferred for simplicity
- **Cost optimized** - B1s VM, minimal AKS nodes
- **Security** - RBAC enabled, SSH key auth, subnet isolation
- **Tagging** - All resources tagged with environment/project
