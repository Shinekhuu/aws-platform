resource "helm_release" "argocd" {

  name = "argocd"
  namespace = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"

  chart = "argo-cd"

  depends_on = [
    helm_release.alb_controller
  ]
  
}