resource "helm_release" "argocd" {
  name      = "argocd"
  namespace = "argocd"

  repository = "https://argoproj.github.io/argo-helm"

  chart = "argo-cd"

  values = [
    <<EOF
server:
  service:
    type: ClusterIP
EOF
  ]

  depends_on = [
    helm_release.alb_controller
  ]
}