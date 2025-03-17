# resource "kubernetes_manifest" "self_signed_certificate" {
#   manifest = {
#     apiVersion = "cert-manager.io/v1"
#     kind       = "Certificate"
#     metadata = {
#       name      = "my-tls-cert"
#       namespace = "default"
#     }
#     spec = {
#       secretName = "my-tls-secret"
#       issuerRef = {
#         name = "self-signed-issuer"
#         kind = "ClusterIssuer"
#       }
#       dnsNames = [
#         "egas.com"
#       ]
#     }
#   }
#   depends_on = [kubernetes_manifest.self_signed_issuer]
# }
