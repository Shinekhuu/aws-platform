resource "helm_release" "argocd" {
  
  depends_on = [
    helm_release.alb_controller
  ]

  name = "argocd"
  namespace = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"

  chart = "argo-cd"

  cleanup_on_fail = true
  wait            = true

  replace       = true
  force_update  = true
  recreate_pods = true

  timeout = 1200

  values = [
    <<EOF
    configs:
      secret:
        argocdServerAdminPassword: "${var.argocd_admin_password}"
    EOF
  ]
}