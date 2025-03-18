# Deploy the AWS EBS CSI Driver as an Add-on
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name                = var.eks_cluster_name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.41.0"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"
  service_account_role_arn    = aws_iam_role.ebs_csi_role.arn

  depends_on = [aws_iam_role_policy_attachment.ebs_csi_attach]
}
