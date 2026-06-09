# Platform Infrastructure

Terraform-based Kubernetes platform stack for AWS EKS.

This repository provisions and configures:

- AWS Load Balancer Controller
- External DNS
- ArgoCD
- ArgoCD Image Updater
- Monitoring stack
- Grafana ingress
- ACM certificates
- GitLab registry & GitOps secrets

---

# Structure

```bash
platform/
├── versions.tf
├── variables.tf
├── providers.tf
├── remote-state.tf
│
├── namespaces.tf
├── acm.tf
├── alb-controller.tf
├── external-dns.tf
├── monitoring.tf
├── argocd.tf
├── argocd-image-updater.tf
├── argocd-root-app.tf
├── gitlab-registry-secret.tf
├── gitlab-gitops-secret.tf
├── argocd-ingress.tf
├── grafana-ingress.tf
│
├── iam/
│   └── alb-controller-policy.json
│
└── README.md
```

---

# Requirements

- Terraform >= 1.5
- AWS CLI
- kubectl
- Helm
- Existing EKS Cluster
- Cloudflare DNS Zone

---

# Environment Variables

## Sensitive

Export required secrets before running Terraform.

```bash
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export CLOUDFLARE_API_TOKEN=""
```

---

# Terraform Variables

Example:

```hcl
region               = "ap-northeast-1"
cloudflare_zone_id   = "xxxxxxxxxxxxxxxx"
```

---

# Deploy

Initialize:

```bash
terraform init
```

Plan:

```bash
terraform plan
```

Apply:

```bash
terraform apply
```

---

# Temporary Notes

## IRSA

IRSA removal is currently temporary.

Some components may still use legacy authentication until migration is completed.

---

# Common Issues

## Namespace stuck in Terminating

Error example:

```bash
Error: object is being deleted: namespaces "monitoring" already exists
```

or

```bash
Error: object is being deleted: namespaces "argocd" already exists
```

## One-time cleanup

Run:

```bash
kubectl delete ns argocd --force --grace-period=0

kubectl delete ns monitoring --force --grace-period=0
```

---

## If namespace still terminating

Run:

```bash
kubectl patch namespace argocd \
-p '{"metadata":{"finalizers":[]}}' \
--type=merge

kubectl patch namespace monitoring \
-p '{"metadata":{"finalizers":[]}}' \
--type=merge
```

---

# Helm Error

## Error

```bash
Error: installation failed

cannot re-use a name that is still in use
```

Usually happens with:

```bash
helm_release.alb_controller
```

---

## Fix

Create runtime directory:

```bash
export XDG_RUNTIME_DIR=/tmp/runtime-$UID

mkdir -p $XDG_RUNTIME_DIR

chmod 700 $XDG_RUNTIME_DIR
```

Check installed releases:

```bash
helm list -n kube-system
```

Remove existing ALB controller release:

```bash
helm uninstall aws-load-balancer-controller -n kube-system
```

---

# ArgoCD Admin Password

Generate bcrypt password:

```bash
htpasswd -nbBC 10 "" P@ssw0rd \
| tr -d ':\n' \
| sed 's/$2y/$2a/'
```

---

# Components

## AWS Load Balancer Controller

Manages AWS ALB resources for Kubernetes ingress.

Terraform:
- `alb-controller.tf`

IAM Policy:
- `policies/alb-controller-policy.json`

---

## External DNS

Automatically manages DNS records in Cloudflare.

Terraform:
- `external-dns.tf`

---

## ArgoCD

GitOps deployment platform.

Terraform:
- `argocd.tf`
- `argocd-root-app.tf`
- `argocd-ingress.tf`

---

## ArgoCD Image Updater

Automatically updates image tags from container registry.

Terraform:
- `argocd-image-updater.tf`

---

## Monitoring Stack

Monitoring and observability components.

Terraform:
- `monitoring.tf`
- `grafana-ingress.tf`

---

# Notes

- Namespace cleanup issue usually happens after interrupted Helm/Terraform operations.
- ALB controller Helm conflicts are common after failed installs.
- Use `terraform destroy` carefully in shared environments.

---
