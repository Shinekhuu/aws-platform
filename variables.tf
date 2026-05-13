variable "region" {
  default = "ap-northeast-1"
}

variable "cloudflare_zone_id" {}

variable "domain_name" {
  default = "gocars.mn"
}

variable "cloudflare_api_token" {
  sensitive = true
}

variable "argocd_admin_password" {
  sensitive = true
}

variable "grafana_admin_user" {}

variable "grafana_admin_password" {
  sensitive = true
}