resource "kubernetes_config_map_v1" "platform_config" {

  metadata {
    name      = "platform-config"
    namespace = "argocd"
  }

  data = {
    ACM_CERT_ARN = aws_acm_certificate.main.arn
  }
}