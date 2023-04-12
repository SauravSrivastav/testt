resource "kubernetes_role_binding" "eng_role_binding" {
  count = length(var.eng_namespace_names)

  metadata {
    name      = "${var.eng_namespace_names[count.index]}-rolebinding"
    namespace = var.eng_namespace_names[count.index]
  }

  role_ref {
    kind     = "Role"
    name     = "${var.eng_namespace_names[count.index]}-role"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "${var.eng_namespace_names[count.index]}-sa"
    namespace = var.eng_namespace_names[count.index]
  }

  depends_on = [
    kubernetes_role.eng_role,
    kubernetes_service_account.eng_service_accounts,
    kubernetes_namespace.eng_namespaces,
  ]
}

// resource "kubernetes_role_binding" "pay_role_binding" {
//   count = length(var.pay_namespace_names)

//   metadata {
//     name      = "${var.pay_namespace_names[count.index]}-rolebinding"
//     namespace = var.pay_namespace_names[count.index]
//   }

//   role_ref {
//     kind     = "Role"
//     name     = "${var.pay_namespace_names[count.index]}-role"
//     api_group = "rbac.authorization.k8s.io"
//   }

//   subject {
//     kind      = "ServiceAccount"
//     name      = "${var.pay_namespace_names[count.index]}-sa"
//     namespace = var.pay_namespace_names[count.index]
//   }

//   depends_on = [
//     kubernetes_role.pay_role,
//     kubernetes_service_account.pay_service_accounts,
//     kubernetes_namespace.pay_namespaces,
//   ]
// }

resource "kubernetes_role_binding" "web_role_binding" {
  count = length(var.web_namespace_names)

  metadata {
    name      = "${var.web_namespace_names[count.index]}-rolebinding"
    namespace = var.web_namespace_names[count.index]
  }

  role_ref {
    kind     = "Role"
    name     = "${var.web_namespace_names[count.index]}-role"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "${var.web_namespace_names[count.index]}-sa"
    namespace = var.web_namespace_names[count.index]
  }

  depends_on = [
    kubernetes_role.web_role,
    kubernetes_service_account.web_service_accounts,
    kubernetes_namespace.web_namespaces,
  ]
}
