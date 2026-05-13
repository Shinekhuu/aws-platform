resource "helm_release" "argocd" {
  name = "argocd"

  namespace = kubernetes_namespace_v1.argocd.metadata[0].name

  repository = "https://argoproj.github.io/argo-helm"

  chart = "argo-cd"

  depends_on = [
    helm_release.alb_controller
  ]
  
}