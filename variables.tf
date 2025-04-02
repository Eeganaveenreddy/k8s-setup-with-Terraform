variable "dev" {
  description = "dev environment"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "region name"
  type        = string
  default     = "ap-south-1"
}

variable "node_groups" {
  description = "Map of node groups"
  type = map(object({
    desired_size   = number
    max_size       = number
    min_size       = number
    instance_types = list(string)
    labels        = optional(map(string), {})
  }))
}

variable "eks_clusters" {
  type = map(object({
    name       = string
    role_arn   = string
    subnet_ids = list(string)
  }))
}

# variable "cluster_endpoint" {}
# variable "cluster_certificate_authority_data" {}
