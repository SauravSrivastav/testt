resource "kubernetes_secret" "azuredns_config" {
  metadata {
    name      = "azuredns-config"
    namespace = "cert-manager"
  }
  depends_on = [
    helm_release.cert_manager
  ]

  type = "Opaque"

  data = {
    "client-secret" = var.cluster_sp_scrt
  }
}
