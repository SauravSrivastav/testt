locals {
  all_namespace_names = distinct(concat(var.eng_namespace_names, var.web_namespace_names))
}

// resource "kubernetes_persistent_volume" "npcert_pv" {
//   count = length(local.all_namespace_names)

//   metadata {
//     name = "np${local.all_namespace_names[count.index]}cert-pv"

//     labels = {
//       usage = "npcert-pv"
//     }
//   }

//   spec {
//     storage_class_name = "azurefile-csi"

//     capacity = {
//       storage = "5Gi"
//     }

//     access_modes = [
//       "ReadWriteMany"
//     ]

//     persistent_volume_reclaim_policy = "Retain"

//     persistent_volume_source {
//       azure_file {
//         secret_name = "azure-secret-cert-share"
//         share_name  = "${local.all_namespace_names[count.index]}"
//         read_only   = false
//       }
//     }
//   }
// }

resource "kubernetes_persistent_volume" "nplogs_pv" {
  count = length(local.all_namespace_names)

  metadata {
    name = "np${local.all_namespace_names[count.index]}logs-pv"

    labels = {
      usage = "nplogs-pv"
    }
  }

  spec {
    storage_class_name = "azurefile-csi"

    capacity = {
      storage = "20Gi"
    }

    access_modes = [
      "ReadWriteMany"
    ]

    persistent_volume_reclaim_policy = "Retain"

    persistent_volume_source {
      azure_file {
        secret_name = "azure-secret-logs-share"
        share_name  = "${local.all_namespace_names[count.index]}logs"
        read_only   = false
      }
    }
  }
}
