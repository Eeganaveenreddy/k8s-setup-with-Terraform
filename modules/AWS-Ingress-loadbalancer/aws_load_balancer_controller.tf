resource "kubernetes_service_account" "alb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller_role.arn
    }
  }
}
data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "my_cluster" {
  name = var.eks_cluster_name
}

resource "aws_iam_role_policy_attachment" "alb_controller_policy" {
  policy_arn = aws_iam_policy.alb_controller_policy.arn
  role       = aws_iam_role.alb_controller_role.name
}


resource "aws_iam_role" "alb_controller_role" {
  name = "eks-alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.my_cluster.identity[0].oidc[0].issuer, "https://", "")}"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(data.aws_eks_cluster.my_cluster.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

# Create Kubernetes ClusterRole for permissions
resource "kubernetes_cluster_role" "alb_controller_role" {
  metadata {
    name = "aws-load-balancer-controller"
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["list", "watch"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
}

# Bind the Role to the Service Account
resource "kubernetes_cluster_role_binding" "alb_controller_role_binding" {
  metadata {
    name = "aws-load-balancer-controller-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.alb_controller_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.alb_controller.metadata[0].name
    namespace = "kube-system"
  }
}


resource "null_resource" "alb_crds" {
  provisioner "local-exec" {
    command = "kubectl apply -k https://github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"
  }
}

# Deploy AWS Load Balancer Controller
resource "kubernetes_deployment" "alb_controller_deployment" {
  depends_on = [null_resource.alb_crds]

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

          security_context {
            run_as_non_root = false
            run_as_user     = 0
          }

          args = [
            "--cluster-name=${var.eks_cluster_name}",
            "--ingress-class=alb"
          ]

          env {
            name  = "AWS_REGION"
            value = "ap-south-1"
          }
        }
      }
    }
  }
}
