data "terraform_remote_state" "infra" {
  backend = "remote"

  config = {
    organization = "gocars"

    workspaces = {
      name = "aws-infrastructure"
    }
  }
}