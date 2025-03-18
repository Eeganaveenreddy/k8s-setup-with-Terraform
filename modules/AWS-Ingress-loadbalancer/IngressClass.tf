resource "kubernetes_ingress_class_v1" "alb_ingress_class" {
  metadata {
    name = "alb"
  }

  spec {
    controller = "ingress.k8s.aws/alb"
  }
}
