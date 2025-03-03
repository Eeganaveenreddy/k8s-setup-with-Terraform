resource "kubernetes_service" "app_service" {
  metadata {
    name      = "app-service"
    namespace = "default"
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
