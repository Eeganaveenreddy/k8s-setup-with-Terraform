# Apply the CRDs First

resource "null_resource" "alb_crds" {
  provisioner "local-exec" {
    command = "kubectl apply -k https://github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
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