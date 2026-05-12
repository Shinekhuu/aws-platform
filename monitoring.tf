resource "helm_release" "prometheus" {
  name      = "prometheus"
  namespace = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"

  chart = "kube-prometheus-stack"

  timeout = 1200

  depends_on = [
    helm_release.alb_controller
  ]
}

resource "helm_release" "loki" {
  name      = "loki"
  namespace = "monitoring"

  repository = "https://grafana.github.io/helm-charts"

  chart = "loki-stack"
}