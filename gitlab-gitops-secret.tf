resource "kubernetes_secret_v1" "gitlab_gitops_token" {

  metadata {
    name      = "gitlab-gitops-token"
    namespace = "argocd"
  }

  type = "Opaque"

  data = {
    username = var.gitlab_username
    password = var.gitlab_pat
  }
}