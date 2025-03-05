resource "kubernetes_service" "app_service" {
  metadata {
    name      = "app-service"
    namespace = "default"
    # annotations = {
    #   "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"       # Specify NLB type
    #   "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"  # Change to "internal" if needed
    #   "service.beta.kubernetes.io/aws-load-balancer-healthcheck-protocol" = "TCP"
    #   "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
    #   "service.beta.kubernetes.io/aws-load-balancer-healthcheck-port"     = "traffic-port"
    #   "service.beta.kubernetes.io/aws-load-balancer-name" = "terr-nlb"
    #   "service.beta.kubernetes.io/aws-load-balancer-security-groups" = aws_security_group.nlb_sg.id  # Attach NLB Security Group
    # }
  }

  spec {
    selector = {
      app = "my-app"  # This must match your deployment's labels
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 8080  # Port on your pod
    }

    type = "LoadBalancer"  # Can also be "ClusterIP" if using an ALB
  }
}
