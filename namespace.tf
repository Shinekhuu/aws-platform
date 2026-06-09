resource "kubernetes_namespace_v1" "frontend" {

  metadata {
    name = "frontend"
  }
}

resource "kubernetes_namespace_v1" "backend" {

  metadata {
    name = "backend"
  }
}

resource "kubernetes_namespace_v1" "monitoring" {

  metadata {
    name = "monitoring"
  }
}