resource "kubernetes_manifest" "argocd_root_app" {

  depends_on = [
    helm_release.argocd
  ]

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"

    metadata = {
      name      = "gocars"
      namespace = "argocd"
    }

    spec = {
      project = "default"

      source = {
        repoURL        = "https://gitlab.com/terraform6043020/aws/gitops.git"
        targetRevision = "HEAD"
        path           = "argocd"
      }

      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "argocd"
      }

      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}