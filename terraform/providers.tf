provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

provider "helm" {
  kubernetes {
    host = "https://192.168.49.2:8443"

    client_certificate     = file("~/.minikube/profiles/minikube/client.crt")
    client_key             = file("~/.minikube/profiles/minikube/client.key")
    cluster_ca_certificate = file("~/.minikube/ca.crt")
  }
}