
resource "kubernetes_namespace" "externaldns" {
  metadata {
    name = "externaldns"
  }
}

# Define the Secret resource for Azure configuration
resource "kubernetes_secret" "azure_config" {
  metadata {
    name = "azure-config"
    namespace = "externaldns"
  }
  depends_on = [
    kubernetes_namespace.externaldns
  ]

  data = { "azure.json" = jsonencode({
    tenantId = data.azurerm_subscription.current.tenant_id
    subscriptionId = data.azurerm_subscription.current.subscription_id
    resourceGroup = data.azurerm_resource_group.apimrg.name
    aadClientId = data.azuread_application.spcluster.application_id
    aadClientSecret = var.cluster_sp_scrt
  })
}

}

# Define the ServiceAccount resource for ExternalDNS
resource "kubernetes_service_account" "externaldns" {
  metadata {
    name = "externaldns"
    namespace = "externaldns"
  }
  depends_on = [
    kubernetes_namespace.externaldns
  ]
}

# Define the ClusterRole resource for ExternalDNS
resource "kubernetes_cluster_role" "externaldns" {
  metadata {
    name = "externaldns"
  }

  rule {
    api_groups = [""]
    resources = ["services", "endpoints", "pods"]
    verbs = ["get", "watch", "list"]
  }

  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources = ["ingresses"]
    verbs = ["get", "watch", "list"]
  }

  rule {
    api_groups = [""]
    resources = ["nodes"]
    verbs = ["get", "watch", "list"]
  }
}

# Define the ClusterRoleBinding resource for ExternalDNS
resource "kubernetes_cluster_role_binding" "externaldns_viewer" {
  metadata {
    name = "externaldns-viewer"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role.externaldns.metadata[0].name
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.externaldns.metadata[0].name
    namespace = kubernetes_service_account.externaldns.metadata[0].namespace
  }
  depends_on = [
    kubernetes_namespace.externaldns
  ]
}

# Define the Deployment resource for ExternalDNS
resource "kubernetes_deployment" "externaldns" {
  metadata {
    name = "externaldns"
    namespace = "externaldns"
  }
  depends_on = [
    kubernetes_namespace.externaldns,
  ]

  spec {
    selector {
      match_labels = {
        app = "externaldns"
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          app = "externaldns"
        }
      }

      spec {
        node_selector = {
          agentpool = "syspool"
        }

        service_account_name = kubernetes_service_account.externaldns.metadata[0].name

        container {
          name = "externaldns"
          image = "registry.k8s.io/external-dns/external-dns:v0.13.4"

          args = [
            "--source=service",
            "--source=ingress",
            "--domain-filter=${var.domain}",
            "--provider=azure-private-dns",
            "--azure-resource-group=${data.azurerm_resource_group.apimrg.name}",
            "--azure-subscription-id=${data.azurerm_subscription.current.subscription_id}",
          ]

          volume_mount {
            name = "azure-config"
            mount_path = "/etc/kubernetes/"
            read_only = true
          }


        }
          volume {
            name = "azure-config"
            secret {
              secret_name = kubernetes_secret.azure_config.metadata[0].name
            }
          }
      }
    }
  }

}
