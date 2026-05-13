resource "helm_release" "external_dns" {

  depends_on = [
    helm_release.alb_controller
  ]

  name      = "external-dns"
  namespace = "kube-system"

  repository = "https://kubernetes-sigs.github.io/external-dns"

  chart = "external-dns"

  timeout = 1200

  set = [
    {
      name  = "provider"
      value = "cloudflare"
    },
    {
      name  = "env[0].name"
      value = "CF_API_TOKEN"
    },
    {
      name  = "policy"
      value = "sync"
    },
    {
      name  = "registry"
      value = "txt"
    },
    {
      name  = "txtOwnerId"
      value = "gocars"
    }
  ]

  set_sensitive = [
    {
      name  = "env[0].value"
      value = var.cloudflare_api_token
    }
  ]
}