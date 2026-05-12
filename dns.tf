resource "cloudflare_dns_record" "argocd" {

  depends_on = [
    kubernetes_ingress_v1.argocd
  ]

  zone_id = var.cloudflare_zone_id

  name = "argocd"
  type = "CNAME"

  content = kubernetes_ingress_v1.argocd.status[0].load_balancer[0].ingress[0].hostname

  ttl = 1

  proxied = true
}

resource "cloudflare_dns_record" "grafana" {
  zone_id = var.cloudflare_zone_id

  name = "grafana"
  ttl = 1
  type = "CNAME"

  content = kubernetes_ingress_v1.grafana.status[0].load_balancer[0].ingress[0].hostname

  proxied = true
}