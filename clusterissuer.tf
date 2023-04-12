// resource "kubernetes_manifest" "clusterissuer" {
//   manifest = {
//     apiVersion = "cert-manager.io/v1"
//     kind       = "ClusterIssuer"
//     metadata = {
//       name = "letsencrypt"
//     }
//     spec = {
//       acme = {
//         server = "https://acme-v02.api.letsencrypt.org/directory"
//         email  = "it@noonpayments.com"
//         privateKeySecretRef = {
//           name = "letsencrypt"
//         }
//         solvers = [
//           {
//             dns01 = {
//               azureDNS = {
//                 clientID = data.azuread_application.spcluster.application_id
//                 clientSecretSecretRef = {
//                   name = "azuredns-config"
//                   key  = "client-secret"
//                 }
//                 subscriptionID    =  "878d7669-9de0-432e-9a2e-2b38c9f9e7d4"
//                 tenantID          = data.azurerm_subscription.current.tenant_id
//                 resourceGroupName = "DOMAIN"
//               }
//             }
//           }
//         ]
//       }
//     }
//   }
// }
