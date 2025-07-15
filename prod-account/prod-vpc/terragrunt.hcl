// locals {
//   params = yamldecode(sops_decrypt_file(find_in_parent_folders("shared-parameters.sops.yaml")))
// }
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::174950171951:role/admin"
  }
  forbidden_account_ids = [
    "" #no standard terraform modules run against the root account
  ]
  ignore_tags {
    key_prefixes = [
      "kubernetes.io/",
      "AutoTag"
      ]
  }
  version = "~> 3.0"
}
EOF
}
generate "tf-version" {
  path      = "tf-version.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "1.0.2"
}
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "prod-tf-live"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "prod-tf-infra"
    role_arn       = "arn:aws:iam::174950171951:role/admin"
  }
}
generate "env_file" {
  path      = "env.tf"
  if_exists = "overwrite"
  contents  = <<EOF
variable "environment" {
  type = string
  default = "prd"
}
variable "region" {
  type = string
  default = "us-east-1"
}
variable "account_id" {
   type = string
   default = "174950171951"
}
EOF
}