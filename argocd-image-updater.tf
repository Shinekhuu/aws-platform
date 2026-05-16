resource "helm_release" "argocd_image_updater" {

  depends_on = [
    helm_release.argocd
  ]

  name       = "argocd-image-updater"
  namespace  = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-image-updater"

  cleanup_on_fail = true
  wait            = true

  replace       = true
  force_update  = true
  recreate_pods = true

  timeout = 1200

  values = [
<<EOF
config:
  registries:
    - name: GitLab
      api_url: https://gitlab.com
      prefix: registry.gitlab.com
      ping: yes
      credentials: pullsecret:frontend/gitlab-registry
EOF
  ]
}