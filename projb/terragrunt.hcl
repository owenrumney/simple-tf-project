  include "external" {
    path = "../external-module/common.hcl"
  }

terraform {
  source = "../proja/"
}
