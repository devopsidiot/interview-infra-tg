terraform {
  source = "git@github.com:devopsidiot/interview-infra-tf.git//irsa-secrets-manager"
}

dependency "eks" {
  config_path = "../../eks"
}

dependency "shared" {
  config_path = "../manager-solo"
}

inputs = {
  environment = "prod"
  secret_arns = [
    dependency.shared.outputs.secret_arn
    ]
  oidc_provider_url = dependency.eks.outputs.cluster_oidc_issuer_url
}

include {
  path = find_in_parent_folders()
}