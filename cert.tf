// resource "kubernetes_manifest" "namespace_cert" {
//     count = length(var.eng_namespace_names)

//     manifest = {
//       apiVersion = "cert-manager.io/v1"
//       kind       = "Certificate"
//       metadata = {
//         name      = "${var.eng_namespace_names[count.index]}-cert"
//         namespace = var.eng_namespace_names[count.index]
//       }
//       spec = {
//         secretName = "${var.eng_namespace_names[count.index]}-scrt"
//         privateKey = {
//           rotationPolicy = "Always"
//         }
//         commonName = "${var.eng_namespace_names[count.index]}.${var.domain}"
//         issuerRef = {
//           name = "letsencrypt"
//           kind = "ClusterIssuer"
//         }
//         dnsNames = [
//           "${var.eng_namespace_names[count.index]}.${var.domain}",
//             var.domain
//         ]
//         usages = [
//           "digital signature",
//           "key encipherment",
//           "server auth"
//         ]
//       }
//     }
//   }