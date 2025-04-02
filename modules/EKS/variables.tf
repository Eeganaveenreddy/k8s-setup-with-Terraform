variable "subnet_ids" {
    type = list(string)
}

variable "eks_policy_attach" {
  type = string
}

variable "role_arn" {
    type = string
}

variable "eks_cluster_role" {
  type = string
}

variable "node_groups" {
  description = "Map of node groups"
  type = map(object({
    cluster_name = string
    desired_size = number
    max_size     = number
    min_size     = number
    instance_types = list(string)
    labels        = optional(map(string), {})
  }))
}

variable "region" {
  default = "ap-south-1"
  type = string
}

variable "cluster_names" {
  type    = list(string)
  default = ["eks-cluster-1", "eks-cluster-2", "eks-cluster-3"]
}