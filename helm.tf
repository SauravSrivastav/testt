# Create a new Helm release for the Jetstack cert-manager
resource "helm_release" "cert_manager" {
  # Set the name of the Helm release
  name = "cert-manager"
  #namespace
  namespace = "cert-manager"
   # Create the namespace if it does not already exist
  create_namespace = true

  # Set the repository URL for the Jetstack cert-manager chart
  repository = "https://charts.jetstack.io"
  # Set the name of the chart to install
  chart = "cert-manager"
  # Set the version of the chart to install
  version = "v1.5.3"

  # Set the installCRDs option to true
  set {
    name  = "installCRDs"
    value = "true"
  }
  timeout = 720
}

# Create a new Helm release resource named "ingress_nginx"
resource "helm_release" "ingress_nginx-eng" {
  # Set the name of the release to "ingress-nginx"
  name             = "ingress-nginx-eng"
  # Set the namespace where the release will be deployed to "ingress-nginx"
  namespace        = "ingress-nginx-eng"
  # Create the namespace if it does not already exist
  create_namespace = true
  # Set the chart to be deployed to "ingress-nginx"
  chart            = "ingress-nginx"
  # Set the repository where the chart can be found
  repository       = "https://kubernetes.github.io/ingress-nginx"

  # Set the number of replicas for the controller to 2
  set {
    name  = "controller.replicaCount"
    value = "2"
  }

  # Set the node selector for the controller to only run on Linux nodes
  set {
    name  = "controller.nodeSelector.kubernetes\\.io/os" # The backslashes are used to escape the dots in the name
    value = "linux"
  }

   set {
    name  = "controller.ingressClassResource.name"
    value = "ingress-nginx-eng"
  }

  # ingress class name which will be used in ingress kind
  set {
    name  = "controller.ingressClassResource.controllerValue"
    value = "k8s.io/ingress-nginx-eng"
  }

  # Set the node selector for the admission webhooks patch to only run on Linux nodes
  set {
    name  = "controller.admissionWebhooks.patch.nodeSelector.kubernetes\\.io/os" # The backslashes are used to escape the dots in the name
    value = "linux"
  }

  # Set an annotation for the controller service to use an internal Azure load balancer
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal" # The backslashes are used to escape the dots in the name
    value = "true"
  }

  # Set the load balancer IP for the controller service
  set {
    name  = "controller.service.loadBalancerIP"
    value = var.clusterip_eng
  }
  timeout = 1440
}


# Create a new Helm release resource named "ingress_nginx"
resource "helm_release" "ingress_nginx-web" {
  # Set the name of the release to "ingress-nginx"
  name             = "ingress-nginx-web"
  # Set the namespace where the release will be deployed to "ingress-nginx"
  namespace        = "ingress-nginx-web"
  # Create the namespace if it does not already exist
  create_namespace = true
  # Set the chart to be deployed to "ingress-nginx"
  chart            = "ingress-nginx"
  # Set the repository where the chart can be found
  repository       = "https://kubernetes.github.io/ingress-nginx"

  # Set the number of replicas for the controller to 2
  set {
    name  = "controller.replicaCount"
    value = "2"
  }

  # Set the node selector for the controller to only run on Linux nodes
  set {
    name  = "controller.nodeSelector.kubernetes\\.io/os" # The backslashes are used to escape the dots in the name
    value = "linux"
  }


  set {
    name  = "controller.ingressClassResource.name"
    value = "ingress-nginx-web"
  }

  # ingress class name which will be used in ingress kind
  set {
    name  = "controller.ingressClassResource.controllerValue"
    value = "k8s.io/ingress-nginx-web"
  }

  # Set the node selector for the admission webhooks patch to only run on Linux nodes
  set {
    name  = "controller.admissionWebhooks.patch.nodeSelector.kubernetes\\.io/os" # The backslashes are used to escape the dots in the name
    value = "linux"
  }

  # Set an annotation for the controller service to use an internal Azure load balancer
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal" # The backslashes are used to escape the dots in the name
    value = "true"
  }

  # Set the load balancer IP for the controller service
  set {
    name  = "controller.service.loadBalancerIP"
    value = var.clusterip_web
  }
  timeout = 1440
}

