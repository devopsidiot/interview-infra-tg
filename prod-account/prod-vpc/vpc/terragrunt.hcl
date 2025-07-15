terraform {
  source = "git@github.com:devopsidiot/interview-infra-tf.git//vpc"
}
inputs = {

  vpc_name = "prod-vpc"
  vpc_cidr = "10.1.0.0/16"

  vpc_azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
include {
  path = find_in_parent_folders()
}