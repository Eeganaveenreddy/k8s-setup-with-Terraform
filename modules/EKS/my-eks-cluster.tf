resource "aws_eks_cluster" "eks_cluster" {
  # name     = "my-eks-cluster"
  count    = length(var.cluster_names)
  name     = var.cluster_names[count.index]
  role_arn = var.role_arn

  vpc_config {
    # subnet_ids = ["subnet-xxxxxx", "subnet-yyyyyy"] # Use your subnet IDs
    subnet_ids = var.subnet_ids
  }
    depends_on = [ var.eks_policy_attach ]
}


# resource "null_resource" "update_kubeconfig" {
#   provisioner "local-exec" {
#     command = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.eks_cluster.name} && kubectl cluster-info && sleep 60"
#     interpreter = ["sh", "-c"]  # Ensures compatibility with Linux/Mac shell
#   }
#   depends_on = [ aws_eks_cluster.eks_cluster ]
  
# }

resource "null_resource" "update_kubeconfig" {
  for_each = toset(var.cluster_names)
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.region} --name ${each.value} --alias ${each.value}"
  }
  depends_on = [aws_eks_cluster.eks_cluster]
}




# output "eks_cluster_name_output" {
#   value = aws_eks_cluster.eks_cluster.name
# }

output "eks_cluster_name_output" {
  value = [for cluster in aws_eks_cluster.eks_cluster : cluster.name]
}


# output "eks_cluster_endpoint" {
#   value = aws_eks_cluster.eks_cluster.endpoint
# }

output "eks_cluster_endpoint" {
  value = [for cluster in aws_eks_cluster.eks_cluster : cluster.endpoint]
}


# output "eks_cluster_certificate_authority_data" {
#   value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
# }

output "eks_cluster_certificate_authority_data" {
  value = [for cluster in aws_eks_cluster.eks_cluster : cluster.certificate_authority[0].data]
}


