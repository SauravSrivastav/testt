resource "kubernetes_cluster_role" "pv_cluster_role" {
  metadata {
    name = "pv-cluster-role"
  }

  rule {
    api_groups = ["*"]
    resources  = ["persistentvolumes"]
    verbs      = ["*"]
  }
}
