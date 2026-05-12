resource "helm_release" "prometheus" {
  name      = "prometheus"
  namespace = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"

  chart = "kube-prometheus-stack"
}

resource "helm_release" "loki" {
  name      = "loki"
  namespace = "monitoring"

  repository = "https://grafana.github.io/helm-charts"

  chart = "loki-stack"
}