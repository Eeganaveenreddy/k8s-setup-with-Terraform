resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "null_resource" "apply_cert_manager" {
  provisioner "local-exec" {
    command = <<EOT
      wget -q --retry-connrefused --waitretry=5 --timeout=10 --tries=3 -O cert-manager.yaml "https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml" && \
      kubectl apply --validate=false -f cert-manager.yaml
    EOT
  }

  depends_on = [kubernetes_namespace.cert_manager]
}

resource "kubectl_manifest" "letsencrypt_issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: "enreddy619@gmail.com"
    server: "https://acme-v02.api.letsencrypt.org/directory"
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: alb
YAML
  depends_on = [null_resource.apply_cert_manager]
}
