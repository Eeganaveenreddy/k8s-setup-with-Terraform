resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = var.role_arn

  vpc_config {
    # subnet_ids = ["subnet-xxxxxx", "subnet-yyyyyy"] # Use your subnet IDs
    subnet_ids = var.subnet_ids
  }

#   depends_on = [aws_iam_role_policy_attachment.eks_policy_attach]
    depends_on = [ var.eks_policy_attach ]
}

resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.eks_cluster.name}"
  }
  depends_on = [ aws_eks_cluster.eks_cluster ]
  
}


output "eks_cluster_name_output" {
  value = aws_eks_cluster.eks_cluster.name
}


