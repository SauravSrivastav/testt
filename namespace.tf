resource "kubernetes_namespace" "eng_namespaces" {
  count = length(var.eng_namespace_names)
  metadata {
    name = var.eng_namespace_names[count.index]
    annotations = {
      "scheduler.alpha.kubernetes.io/node-selector" = "layer=eng"
    }
  }
}

// resource "kubernetes_namespace" "pay_namespaces" {
//   count = length(var.pay_namespace_names)
//   metadata {
//     name = var.pay_namespace_names[count.index]
//     annotations = {
//       "scheduler.alpha.kubernetes.io/node-selector" = "layer=pay"
//     }
//   }
// }

resource "kubernetes_namespace" "web_namespaces" {
  count = length(var.web_namespace_names)
  metadata {
    name = var.web_namespace_names[count.index]
    annotations = {
      "scheduler.alpha.kubernetes.io/node-selector" = "layer=web"
    }
  }
}
