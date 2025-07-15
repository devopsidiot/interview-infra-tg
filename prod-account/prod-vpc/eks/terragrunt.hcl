terraform {
  source = "git@github.com:devopsidiot/interview-infra-tf.git"
}
dependency "vpc" {
  config_path = "../vpc"
}
dependencies {
  paths = ["../vpn"]
}
inputs = {
  secrets = {
    argo   = "arn:aws:ssm:us-east-1:174950171951:parameter/argocd/*"
    vendor = "arn:aws:ssm:us-east-1:174950171951:parameter/vendor/*"
  }

  environment            = "prod"
  kubeconfig_role        = "arn:aws:iam::174950171951:role/admin"
  cluster_name           = "prod-eks"
  private_subnets        = dependency.vpc.outputs.private_subnets
  vpc_cidr               = dependency.vpc.outputs.vpc_cidr
  default_sg_id          = dependency.vpc.outputs.default_sg_id
  public_subnets         = dependency.vpc.outputs.public_subnets
  vpc_id                 = dependency.vpc.outputs.vpc_id
  home_dir               = get_env("HOME", ".")
  eks_cluster_version    = "1.26"
  sops_file              = "${get_terragrunt_dir()}/../../.sops.yaml"
  decrypt_script         = "${get_terragrunt_dir()}/../../decrypt"
  encrypt_script         = "${get_terragrunt_dir()}/../../encrypt"
  shared_parameters_yaml = "${get_terragrunt_dir()}/../../shared-parameters.decrypted.yaml"
  gitignore              = "${get_terragrunt_dir()}/../../.gitignore"
  use_spot_karpenter     = true
  api_namespaces         = ["prod"]
}
include {
  path = find_in_parent_folders()
}
