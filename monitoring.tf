resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus" {

  depends_on = [
    helm_release.alb_controller
  ]

  name      = "prometheus"
  namespace = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"

  chart = "kube-prometheus-stack"

  timeout = 1200
}

resource "helm_release" "loki" {

  depends_on = [
    helm_release.prometheus
  ]

  name      = "loki"
  namespace = "monitoring"

  repository = "https://grafana.github.io/helm-charts"

  chart = "loki-stack"

  timeout = 1200
}