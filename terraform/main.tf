resource "helm_release" "dd" {
  name       = "datadog"                    # var.chart_name datadog
  repository = "https://helm.datadoghq.com" #var.kong_helm.chart_url
  chart      = "datadog"
  version    = "3.3.0"
  namespace  = "default"
  force_update = true
  recreate_pods = true

  # Inject all config with this file
  values = [
    sensitive(templatefile("${path.root}/helm/values-datadog.yaml.tpl", {
      api_key = "<API-KEY>"
      app_key = "<APP-KEY>"
    }))
  ]
}