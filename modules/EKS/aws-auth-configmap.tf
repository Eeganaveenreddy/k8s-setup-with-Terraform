resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = <<YAML
    - userarn: arn:aws:iam::288761760029:user/kalyani-10
      username: kalyani-10
      groups:
        - system:masters
    YAML
    mapRoles = <<YAML
    - rolearn: arn:aws:iam::288761760029:role/eks-console-access
      username: eks-console-access
      groups:
        - system:masters
    - rolearn: ${var.role_arn}
      username: ${var.eks_cluster_role}
      groups:
        - system:masters
    - rolearn: arn:aws:iam::288761760029:role/eks-node-group-role
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: arn:aws:iam::288761760029:role/eks-alb-controller-role
      username: "system:serviceaccount:kube-system:aws-load-balancer-controller"
      groups:
        - system:bootstrappers
        - system:nodes
        - system:masters
    YAML
  }

   # Prevent Terraform from recreating the existing aws-auth ConfigMap
  # lifecycle {
  #   ignore_changes = [data]
  # }
}
