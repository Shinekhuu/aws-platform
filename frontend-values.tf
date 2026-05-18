resource "local_file" "frontend_values" {

  content = yamlencode({

    ingress = {
      host = "frontend.${var.domain_name}"

      acmCertificateArn = aws_acm_certificate.main.arn
    }
  })

  filename = "${path.module}/../gitops/apps/frontend/values.yaml"
}