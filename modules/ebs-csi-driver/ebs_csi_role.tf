# Create an IAM Role for the EBS CSI Driver
resource "aws_iam_role" "ebs_csi_role" {
  name = "AmazonEKS_EBS_CSI_DriverRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks_oidc.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(data.aws_eks_cluster.my_cluster.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }]
  })
}


data "aws_eks_cluster" "my_cluster" {
  name = var.eks_cluster_name
}
data "aws_eks_cluster_auth" "eks_auth" {
  name = data.aws_eks_cluster.my_cluster.name
}

# Fetch OIDC Provider Details
data "tls_certificate" "tls_cert" {
  url = data.aws_eks_cluster.my_cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.tls_cert.certificates.0.sha1_fingerprint]
  url = data.aws_eks_cluster.my_cluster.identity.0.oidc.0.issuer
}


# data "aws_iam_openid_connect_provider" "oidc" {
#   url = data.aws_eks_cluster.my_cluster.identity[0].oidc[0].issuer
# }

resource "aws_iam_role_policy_attachment" "ebs_csi_attach" {
  role       = aws_iam_role.ebs_csi_role.name
  # policy_arn = aws_iam_policy.ebs_csi_policy.arn
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

output "ebs_csi_iam_role_arn" {
  value = aws_iam_role.ebs_csi_role.arn
}






