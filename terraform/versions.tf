#-------------
# PIN VERSIONS
#-------------
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.1"
    }
    kubernetes = "~> 2.15.0"
    local      = "~> 2.1.0"
    null       = "~> 3.1.0"
    random     = "~> 3.1.0"
  }
}
