resource "kubernetes_ingress_v1" "argocd" {

  wait_for_load_balancer = true

  depends_on = [
    helm_release.argocd
  ]

  metadata {
    name      = "argocd"
    namespace = "argocd"

    annotations = {

      "kubernetes.io/ingress.class" = "alb"

      "alb.ingress.kubernetes.io/scheme" = "internet-facing"

      "alb.ingress.kubernetes.io/target-type" = "ip"

      "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\":80},{\"HTTPS\":443}]"

      "alb.ingress.kubernetes.io/ssl-redirect" = "443"

      "alb.ingress.kubernetes.io/backend-protocol" = "HTTPS"

      "alb.ingress.kubernetes.io/certificate-arn" = aws_acm_certificate.main.arn

      "external-dns.alpha.kubernetes.io/hostname" = "argocd.${var.domain_name}"
    }
  }

  spec {
    rule {

      host = "argocd.${var.domain_name}"

      http {
        path {

          path      = "/"
          path_type = "Prefix"

          backend {
            service {

              name = "argocd-server"

              port {
                number = 443
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "grafana" {

  wait_for_load_balancer = true

  depends_on = [
    helm_release.prometheus
  ]

  metadata {
    name      = "grafana"
    namespace = "monitoring"

    annotations = {
      "kubernetes.io/ingress.class" = "alb"

      "alb.ingress.kubernetes.io/scheme" = "internet-facing"

      "alb.ingress.kubernetes.io/target-type" = "ip"

      "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\":80},{\"HTTPS\":443}]"

      "alb.ingress.kubernetes.io/ssl-redirect" = "443"

      "alb.ingress.kubernetes.io/certificate-arn" = aws_acm_certificate.main.arn

      "external-dns.alpha.kubernetes.io/hostname" = "grafana.${var.domain_name}"
    }
  }

  spec {
    rule {
      host = "grafana.${var.domain_name}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "prometheus-grafana"

              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}