platform/
├── versions.tf
├── variables.tf
├── outputs.tf
│
├── providers.tf
├── remote-state.tf
│
├── acm.tf
├── namespaces.tf
├── gitlab-registry-secret.tf
│
├── alb-controller.tf
├── external-dns.tf
│
├── argocd.tf
├── argocd-root-app.tf
├── argocd-image-updater.tf
│
├── monitoring.tf
├── ingress.tf
│
├── iam/
│   └── alb-controller-policy.json
│
└── README.md

✔ Sensitive & ENV
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
CLOUDFLARE_API_TOKEN

✔ Environment-specific & Terraform variables
region
cloudflare_zone_id


TODO: IRSA remove хийж байна temporarily.

IF: Error: object is being deleted: namespaces "monitoring" or "argocd" already exists
🥇 Need ONE-TIME manual cleanup

ONLY ONCE 😄

Run:
kubectl delete ns argocd --force --grace-period=0
kubectl delete ns monitoring --force --grace-period=0

🥈 If still terminating

Then:

kubectl patch namespace argocd \
-p '{"metadata":{"finalizers":[]}}' \
--type=merge
kubectl patch namespace monitoring \
-p '{"metadata":{"finalizers":[]}}' \
--type=merge

-----------

Error: installation failed
with helm_release.alb_controller
on alb-controller.tf line 41, in resource "helm_release" "alb_controller":
resource "helm_release" "alb_controller"
cannot re-use a name that is still in use

🥇 Fastest fix

Run:

export XDG_RUNTIME_DIR=/tmp/runtime-$UID && \
mkdir -p $XDG_RUNTIME_DIR && \
chmod 700 $XDG_RUNTIME_DIR

helm list -n kube-system

helm uninstall aws-load-balancer-controller -n kube-system

----------

For argocd password generate:
htpasswd -nbBC 10 "" P@ssw0rd \
| tr -d ':\n' \
| sed 's/$2y/$2a/'