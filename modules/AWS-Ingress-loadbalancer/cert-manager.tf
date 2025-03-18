# # Create the cert-manager namespace
# resource "kubernetes_namespace" "cert_manager" {
#   metadata {
#     name = "cert-manager"
#   }
# }

# # Install Cert-Manager CRDs
# resource "null_resource" "apply_cert_manager_crds" {
#   provisioner "local-exec" {
#     command = <<EOT
#       wget -q --retry-connrefused --waitretry=5 --timeout=10 --tries=3 -O cert-manager.crds.yaml "https://github.com/cert-manager/cert-manager/releases/download/v1.5.4/cert-manager.crds.yaml" && \
#       kubectl apply -f cert-manager.crds.yaml
#     EOT
#   }
# depends_on = [kubernetes_namespace.cert_manager]
# }


# #  Install Cert-Manager (Manually)

# resource "kubernetes_manifest" "cert_manager_install" {
#     depends_on = [ null_resource.apply_cert_manager_crds ]
#   manifest = {
#     apiVersion = "apps/v1"
#     kind       = "Deployment"
#     metadata = {
#       name      = "cert-manager"
#       namespace = "cert-manager"
#     }
#     spec = {
#       replicas = 1
#       selector = {
#         matchLabels = {
#           app = "cert-manager"
#         }
#       }
#       template = {
#         metadata = {
#           labels = {
#             app = "cert-manager"
#           }
#         }
#         spec = {
#           containers = [{
#             name  = "cert-manager"
#             image = "quay.io/jetstack/cert-manager:v1.5.4"
#           }]
#         }
#       }
#     }
#   }
# }
