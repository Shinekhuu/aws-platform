data "terraform_remote_state" "infra" {
  backend = "remote"

  config = {
    organization = "gocars"

    workspaces = {
      name = "aws-infrastructure"
    }
  }
}

data "aws_eks_cluster" "this" {
  name = data.terraform_remote_state.infra.outputs.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}