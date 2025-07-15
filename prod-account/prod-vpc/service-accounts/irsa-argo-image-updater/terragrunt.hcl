terraform {
  source = "git@github.com:devopsidiot/interview-infra-tf.git//irsa-argo-image-updater"
}

dependency "eks" {
  config_path = "../../eks"
}

inputs = {
  environment       = "prod"
  oidc_provider_url = dependency.eks.outputs.cluster_oidc_issuer_url
}

include {
  path = find_in_parent_folders()
}