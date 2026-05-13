resource "aws_iam_policy" "alb_controller" {
  name = "AWSLoadBalancerControllerIAMPolicy"

  policy = file("${path.module}/iam/alb-controller-policy.json")
}

resource "aws_iam_role" "alb_controller" {
  name = "alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Federated = data.terraform_remote_state.infra.outputs.oidc_provider_arn
      }

      Action = "sts:AssumeRoleWithWebIdentity"

      Condition = {
        StringEquals = {
          "${replace(
            data.terraform_remote_state.infra.outputs.oidc_provider_url,
            "https://",
            ""
          )}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  role = aws_iam_role.alb_controller.name

  policy_arn = aws_iam_policy.alb_controller.arn
}

resource "helm_release" "alb_controller" {

  depends_on = [
    aws_iam_role_policy_attachment.alb_controller
  ]

  name      = "aws-load-balancer-controller"
  namespace = "kube-system"
  create_namespace = true

  repository = "https://aws.github.io/eks-charts"

  chart = "aws-load-balancer-controller"

  cleanup_on_fail  = true
  wait             = true

  replace          = true
  force_update     = true
  recreate_pods    = true

  timeout = 1200

  set = [
    {
      name  = "clusterName"

      value = data.terraform_remote_state.infra.outputs.cluster_name
    },
    {
      name  = "region"
      value = var.region
    },
    {
      name  = "vpcId"
      value = data.terraform_remote_state.infra.outputs.vpc_id
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"

      value = "aws-load-balancer-controller"
    },
    {
      name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"

      value = aws_iam_role.alb_controller.arn
    }
  ]
}