eks_clusters = {
  cluster1 = {
    name       = "eks-cluster-1"
    role_arn = var.role_arn
    subnet_ids = var.subnet_ids
  }
  cluster2 = {
    name       = "eks-cluster-2"
    role_arn = var.role_arn
    subnet_ids = var.subnet_ids
  }
  cluster3 = {
    name       = "eks-cluster-3"
    role_arn = var.role_arn
    subnet_ids = var.subnet_ids
  }
}