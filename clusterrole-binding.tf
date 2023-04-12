// resource "kubernetes_role_binding" "pv_role_binding" {
//   count = length(var.eng_namespace_names) + length(var.pay_namespace_names) + length(var.web_namespace_names)

//   metadata {
//     name      = "pv-role-binding-${count.index}"
//     namespace = element(concat(var.eng_namespace_names, var.pay_namespace_names, var.web_namespace_names), count.index)
//   }

//   role_ref {
//     api_group = "rbac.authorization.k8s.io"
//     kind      = "ClusterRole"
//     name      = kubernetes_cluster_role.pv_cluster_role.metadata[0].name
//   }

//   subject {
//     kind      = "ServiceAccount"
//     name      = lookup(local.sa_map, count.index, "")
//     namespace = element(concat(var.eng_namespace_names, var.pay_namespace_names, var.web_namespace_names), count.index)
//   }
// }

// locals {
//    sa_map = zipmap(
//     range(length(var.eng_namespace_names) + length(var.pay_namespace_names) + length(var.web_namespace_names)),
//     tolist(setunion(toset(flatten(kubernetes_service_account.eng_service_accounts.*.metadata).*.name), toset(flatten(kubernetes_service_account.pay_service_accounts.*.metadata).*.name), toset(flatten(kubernetes_service_account.web_service_accounts.*.metadata).*.name)))
//   )
// }

// resource "kubernetes_role_binding" "pv_role_binding" {
//   count = length(var.eng_namespace_names)

//   metadata {
//     // name      = "pv-role-binding-${count.index}"
//     name      = "pv-role-binding-${element(var.eng_namespace_names, count.index)}"
//     namespace = element(var.eng_namespace_names, count.index)
//   }

//   role_ref {
//     api_group = "rbac.authorization.k8s.io"
//     kind      = "ClusterRole"
//     name      = kubernetes_cluster_role.pv_cluster_role.metadata[0].name
//   }

//   subject {
//     kind      = "ServiceAccount"
//     name      = lookup(local.sa_map, count.index, "")
//     namespace = element(var.eng_namespace_names, count.index)
//   }
// }

// locals {
//    sa_map = zipmap(
//     range(length(var.eng_namespace_names)),
//     tolist(setunion(toset(flatten(kubernetes_service_account.eng_service_accounts.*.metadata).*.name)))
//   )
// }


resource "kubernetes_role_binding" "pv_role_binding" {
  count = length(var.eng_namespace_names) + length(var.web_namespace_names)

  metadata {
    name      = "pv-role-binding-${count.index}"
    namespace = element(concat(var.eng_namespace_names, var.web_namespace_names), count.index)
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.pv_cluster_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = lookup(local.sa_map, count.index, "")
    namespace = element(concat(var.eng_namespace_names, var.web_namespace_names), count.index)
  }
}

//   lifecycle {
//     ignore_changes = [subject[0].name]
//   }
// }

locals {
   sa_map = zipmap(
    range(length(var.eng_namespace_names) + length(var.web_namespace_names)),
    tolist(setunion(toset(flatten(kubernetes_service_account.eng_service_accounts.*.metadata).*.name), toset(flatten(kubernetes_service_account.web_service_accounts.*.metadata).*.name)))
  )
}
