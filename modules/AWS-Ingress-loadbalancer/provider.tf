# provider "kubernetes" {
#   host                   = var.cluster_endpoint
#   cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
# #   cluster_ca_certificate = base64decode(one(data.aws_eks_cluster.my_cluster.certificate_authority).data)
#   token                  = data.aws_eks_cluster_auth.cluster_auth.token
# }

# data "aws_eks_cluster_auth" "cluster_auth" {
#     name = data.aws_eks_cluster.my_cluster.name
# }

