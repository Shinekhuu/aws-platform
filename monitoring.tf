resource "helm_release" "prometheus" {

  depends_on = [
    helm_release.alb_controller
  ]

  name             = "prometheus"
  namespace        = "monitoring"
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"

  chart = "kube-prometheus-stack"

  cleanup_on_fail = true
  wait            = true

  replace       = true
  force_update  = true
  recreate_pods = true

  timeout = 1200

  values = [
    <<EOF
    grafana:
      adminUser: "${var.grafana_admin_user}"
      adminPassword: "${var.grafana_admin_password}"
      additionalDataSources:
        - name: Loki
          type: loki
          access: proxy
          url: http://loki:3100

    alertmanager:
      enabled: false

    kubeEtcd:
      enabled: false

    kubeScheduler:
      enabled: false

    kubeControllerManager:
      enabled: false
EOF
  ]
}

resource "helm_release" "loki" {

  depends_on = [
    helm_release.prometheus
  ]

  name      = "loki"
  namespace = "monitoring"
  create_namespace = true

  repository = "https://grafana.github.io/helm-charts"

  chart = "loki-stack"

  cleanup_on_fail = true
  wait            = true

  replace         = true
  force_update    = true
  recreate_pods   = true

  timeout = 1200
}