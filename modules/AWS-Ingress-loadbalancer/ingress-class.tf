resource "kubernetes_ingress_class" "alb" {
  metadata {
    name = "alb"
  }

  spec {
    controller = "ingress.k8s.aws/alb"
  }
}
