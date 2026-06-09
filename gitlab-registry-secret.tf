resource "kubernetes_secret_v1" "gitlab_registry" {

  metadata {
    name      = "gitlab-registry"
    namespace = "frontend"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "registry.gitlab.com" = {
          username = var.gitlab_registry_username
          password = var.gitlab_registry_token
          email    = var.gitlab_registry_email

          auth = base64encode(
            "${var.gitlab_registry_username}:${var.gitlab_registry_token}"
          )
        }
      }
    })
  }
}