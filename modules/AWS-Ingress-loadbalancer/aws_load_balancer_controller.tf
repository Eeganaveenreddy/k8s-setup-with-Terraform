# data "aws_caller_identity" "current" {}

# # Create a service account for the ALB controller
# resource "kubernetes_service_account" "alb_controller_sa" {
#   metadata {
#     name      = "aws-load-balancer-controller"
#     namespace = "kube-system"
#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller_iam_role.arn
#     }
#   }
# }

# # Create IAM Role for AWS Load Balancer Controller
# resource "aws_iam_role" "alb_controller_iam_role" {
#   name = "alb-controller-iam-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Effect = "Allow"
#         Principal = {
#           Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.my_cluster.identity[0].oidc[0].issuer, "https://", "")}" 
#         }

#         Condition = {
#           StringEquals = {
#             "${replace(data.aws_eks_cluster.my_cluster.identity[0].oidc[0].issuer, "https://", "")}:aud" = "sts.amazonaws.com" 
#             "${replace(data.aws_eks_cluster.my_cluster.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller" 
#           }
#         } 

#       }
#     ]
#   })
# }

# data "aws_eks_cluster" "my_cluster" {
#   name = var.eks_cluster_name
# }

# resource "aws_iam_role_policy_attachment" "alb_controller_role_policy_attach" {
#   policy_arn = aws_iam_policy.alb_controller_policy.arn
#   role       = aws_iam_role.alb_controller_iam_role.name
# }

resource "null_resource" "alb_crds" {
  provisioner "local-exec" {
    command = "kubectl apply -k https://github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"
  }
}

# Deploy AWS Load Balancer Controller
resource "kubernetes_deployment" "alb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      app = "aws-load-balancer-controller"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "aws-load-balancer-controller"
      }
    }

    template {
      metadata {
        labels = {
          app = "aws-load-balancer-controller"
        }
      }

      spec {
        container {
          image = "602401143452.dkr.ecr.us-west-2.amazonaws.com/amazon/aws-load-balancer-controller:v2.6.1"
          name  = "aws-load-balancer-controller"

          args = [
            "--cluster-name=${var.eks_cluster_name}",
            "--ingress-class=alb"
          ]
        }
      }
    }
  }
}
