data "aws_eks_cluster" "my_cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_eks_cluster_auth" "my_cluster_id" {
  name = data.aws_eks_cluster.my_cluster.id
  depends_on = [data.aws_eks_cluster.my_cluster] # Ensures correct order
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.my_cluster.endpoint
  token                  = data.aws_eks_cluster_auth.my_cluster_id.token
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.my_cluster.certificate_authority[0].data)
  cluster_ca_certificate = base64decode(
  lookup(try(one(data.aws_eks_cluster.my_cluster.certificate_authority), {}), "data", "")
)
}

resource "kubernetes_cluster_role_binding" "eks_console_view" {
  metadata {
    name = "eks-console-view"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "User"
    name      = "kalyani-10"
    api_group = "rbac.authorization.k8s.io"
  }
}


