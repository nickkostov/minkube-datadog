resource "helm_release" "dd" {
  name          = "datadog"                    # var.chart_name datadog
  repository    = "https://helm.datadoghq.com" #var.kong_helm.chart_url
  chart         = "datadog"
  version       = "3.3.0"
  namespace     = "default"
  force_update  = true
  recreate_pods = true

  # Inject all config with this file
  values = [
    sensitive(templatefile("${path.root}/helm/values-datadog.yaml.tpl", {
      api_key      = var.api_key
      app_key      = var.app_key
      datadog_site = var.datadog_site
      cluster_name = var.cluster_name
    }))
  ]
}

#resource "helm_release" "metrics-server" {
#  name          = "metrics-server"                    # var.chart_name datadog
#  repository    = "https://kubernetes-sigs.github.io/metrics-server/" #var.kong_helm.chart_url
#  chart         = "metrics-server"
#  version       = "3.8.2"
#  namespace     = "default"
#  force_update  = true
#  recreate_pods = true
#  # Inject all config with this file
#  #values = [
#  #  sensitive(templatefile("${path.root}/helm/values-datadog.yaml.tpl", {
#  #    api_key      = var.api_key
#  #    app_key      = var.app_key
#  #    datadog_site = var.datadog_site
#  #    cluster_name = var.cluster_name
#  #  }))
#  #]
#}