# resource "kubernetes_manifest" "egas_cert" {
#   manifest = {
#     apiVersion = "cert-manager.io/v1"
#     kind       = "Certificate"
#     metadata = {
#       name      = "egas-tls"
#       namespace = "default"
#     }
#     spec = {
#       secretName = "egas-tls"
#       issuerRef = {
#         name = "letsencrypt-prod"
#         kind = "ClusterIssuer"
#       }
#       dnsNames = ["egas.com"]
#     }
#   }
# }
