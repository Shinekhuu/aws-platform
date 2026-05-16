output "acm_certificate_arn" {
  value = aws_acm_certificate.main.arn
}

output "argocd_url" {
  value = "https://argocd.${var.domain_name}"
}

output "grafana_url" {
  value = "https://grafana.${var.domain_name}"
}