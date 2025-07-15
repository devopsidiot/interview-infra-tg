locals {
  params = yamldecode(sops_decrypt_file(find_in_parent_folders("shared-parameters.sops.yaml")))
}
terraform {
  source = "git@github.com:devopsidiot/interview-infra-tf.git//argocd-app-of-apps"
}
dependency "eks" {
  config_path = "../eks"
}
inputs = {
  argo_environment      = "prd"
  argo_initial_password = local.params.argo_rnd_initial_password
  workloads_directory   = "flux/rnd-cluster/workloads/big-test"
  github_ssh            = local.params.github_ssh
}
include {
  path = find_in_parent_folders()
}