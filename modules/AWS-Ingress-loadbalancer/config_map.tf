resource "kubernetes_config_map" "aws_lb_controller_leader" {
  metadata {
    name      = "aws-load-balancer-controller-leader"
    namespace = "kube-system"
  }
}