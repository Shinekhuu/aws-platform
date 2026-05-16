provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "this" {
  name = data.terraform_remote_state.infrastructure.outputs.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}

provider "kubernetes" {

  host = data.aws_eks_cluster.this.endpoint

  cluster_ca_certificate = base64decode(
    data.aws_eks_cluster.this
      .certificate_authority[0]
      .data
  )

  token = data.aws_eks_cluster_auth.this.token
}

provider "helm" {

  kubernetes = {

    host = data.aws_eks_cluster.this.endpoint

    cluster_ca_certificate = base64decode(
      data.aws_eks_cluster.this
        .certificate_authority[0]
        .data
    )

    token = data.aws_eks_cluster_auth.this.token
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}