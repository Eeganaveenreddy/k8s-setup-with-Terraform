# resource "kubernetes_manifest" "self_signed_issuer" {
#   manifest = {
#     apiVersion = "cert-manager.io/v1"
#     kind       = "ClusterIssuer"
#     metadata = {
#       name = "self-signed-issuer"
#     }
#     spec = {
#       selfSigned = {}
#     }
#   }
#   depends_on = [kubernetes_manifest.cert_manager_install, null_resource.apply_cert_manager_crds]
# }
