terraform {
  source = "git@github.com:devopsidiot/interview-infra-tf.git//elasticache-redis-cluster
}
dependency "vpc" {
  config_path = "../vpc"
}
inputs = {
  name                                 = "prod-redis"
  cluster_size                         = 2
  instance_type                        = "cache.t3.micro"
  availability_zones                   = dependency.vpc.outputs.azs
  vpc_id                               = dependency.vpc.outputs.vpc_id
  subnets                              = dependency.vpc.outputs.database_subnets
  vpc_cidr                             = dependency.vpc.outputs.vpc_cidr
  at_rest_encryption_enabled           = false
  transit_encryption_enabled           = false
  cluster_mode_enabled                 = false
  cluster_mode_num_node_groups         = 0
  cluster_mode_replicas_per_node_group = 0
}

include {
  path = find_in_parent_folders()
}