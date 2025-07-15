locals {
  params = yamldecode(sops_decrypt_file(find_in_parent_folders("shared-parameters.sops.yaml")))
}
terraform {
  source = "git@github.com:devopsidiot/interview-infra-tf.git//flux"
}
dependency "eks" {
  config_path = "../eks"
}
inputs = {
  environment                        = "prod"
  target_path                        = "flux-system"
  cluster_name                       = dependency.eks.outputs.cluster_id
  cluster_endpoint                   = dependency.eks.outputs.cluster_endpoint
  cluster_certificate_authority_data = dependency.eks.outputs.cluster_certificate_authority_data
  cluster_admin_role                 = dependency.eks.outputs.cluster_admin_role
  flux_version                       = "v0.36.0"
  flux_token                         = local.params.github_pat
  flux_branch                        = "main"
  workloads_directory                = "workloads/big-test"
}
include {
  path = find_in_parent_folders()
}