resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<YAML
- rolearn: var.role_arn
  username: eks-cluster-role
  groups:
    - system:masters
YAML
  }

   # Prevent Terraform from recreating the existing aws-auth ConfigMap
  lifecycle {
    ignore_changes = [data]
  }
}
