resource "kubernetes_role" "eng_role" {
  count = length(kubernetes_namespace.eng_namespaces)

  metadata {
    name      = "${var.eng_namespace_names[count.index]}-role"
    namespace = var.eng_namespace_names[count.index]
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }

  depends_on = [    kubernetes_namespace.eng_namespaces  ]
}

// resource "kubernetes_role" "pay_role" {
//   count = length(kubernetes_namespace.pay_namespaces)

//   metadata {
//     name      = "${var.pay_namespace_names[count.index]}-role"
//     namespace = var.pay_namespace_names[count.index]
//   }

//   rule {
//     api_groups = ["*"]
//     resources  = ["*"]
//     verbs      = ["*"]
//   }

//   depends_on = [    kubernetes_namespace.pay_namespaces  ]
// }

resource "kubernetes_role" "web_role" {
  count = length(kubernetes_namespace.web_namespaces)

  metadata {
    name      = "${var.web_namespace_names[count.index]}-role"
    namespace = var.web_namespace_names[count.index]
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }

  depends_on = [    kubernetes_namespace.web_namespaces  ]
}
