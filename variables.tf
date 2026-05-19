variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "cloudflare_zone_id" {
  type = string
}

variable "domain_name" {
  type    = string
  default = "gocars.mn"
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "argocd_admin_password" {
  type      = string
  sensitive = true
}

variable "grafana_admin_user" {
  type = string
}

variable "grafana_admin_password" {
  type      = string
  sensitive = true
}

# GitLab Container Registry
variable "gitlab_registry_username" {
  type      = string
  sensitive = true
}

variable "gitlab_registry_token" {
  type      = string
  sensitive = true
}

variable "gitlab_registry_email" {
  type      = string
  sensitive = true
}

# GitLab GitOps PAT
variable "gitlab_username" {
  type      = string
  sensitive = true
}

variable "gitlab_pat" {
  type      = string
  sensitive = true
}