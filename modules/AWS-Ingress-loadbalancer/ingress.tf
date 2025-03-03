resource "kubernetes_ingress_v1" "app_ingress" {
  metadata {
    name      = "app-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"  # Change to "internal" if needed
      "alb.ingress.kubernetes.io/target-type" = "ip"
      "alb.ingress.kubernetes.io/load-balancer-type" = "nlb"
    }
  }

  spec {
    rule {
      host = "cloudops-platforms.cloud"  # Replace with your domain

      http {
        path {
          path      = "/*"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.app_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
