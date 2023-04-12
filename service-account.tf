resource "kubernetes_service_account" "eng_service_accounts" {
  count = length(var.eng_namespace_names)
  metadata {
    name      = "${var.eng_namespace_names[count.index]}-sa"
    namespace = var.eng_namespace_names[count.index]
  }
  depends_on = [
    kubernetes_namespace.eng_namespaces
  ]
}

// resource "kubernetes_service_account" "pay_service_accounts" {
//   count = length(var.pay_namespace_names)
//   metadata {
//     name      = "${var.pay_namespace_names[count.index]}-sa"
//     namespace = var.pay_namespace_names[count.index]
//   }
//   depends_on = [
//     kubernetes_namespace.pay_namespaces
//   ]
// }

resource "kubernetes_service_account" "web_service_accounts" {
  count = length(var.web_namespace_names)
  metadata {
    name      = "${var.web_namespace_names[count.index]}-sa"
    namespace = var.web_namespace_names[count.index]
  }
  depends_on = [
    kubernetes_namespace.web_namespaces
  ]
}


