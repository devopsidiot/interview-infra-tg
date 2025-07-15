terraform {
  source = "git@github.com:devopsidiot/interview-infra-tf.git//ecr"
}

inputs = {
  repo_name = "argo-image-updater"
}

include {
  path = find_in_parent_folders()
}