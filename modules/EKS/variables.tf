variable "subnet_ids" {
    type = list(string)
}

variable "eks_policy_attach" {}

variable "role_arn" {
    type = string
}

variable "eks_cluster_role" {
  type = string
}

variable "node_groups" {
  description = "Map of node groups"
  type = map(object({
    desired_size = number
    max_size     = number
    min_size     = number
    instance_types = list(string)
  }))
  # default = {
  #   "t3-large-nodes" = {
  #     instance_types = ["t3.large"]
  #     desired_size   = 2
  #     max_size       = 5
  #     min_size       = 1
  #   }
  # }
}

variable "region" {
  default = "ap-south-1"
  type = string
}
