terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = local.settings.region
}

# Using file() to read JSON files outside of this project (12 files total to trigger globbing)
locals {
  settings   = jsondecode(file("${path.module}/../shared-config/settings.json"))
  network    = jsondecode(file("${path.module}/../shared-config/network.json"))
  database   = jsondecode(file("${path.module}/../shared-config/database.json"))
  monitoring = jsondecode(file("${path.module}/../shared-config/monitoring.json"))
  security   = jsondecode(file("${path.module}/../shared-config/security.json"))
  storage    = jsondecode(file("${path.module}/../shared-config/storage.json"))
  compute    = jsondecode(file("${path.module}/../shared-config/compute.json"))
  logging    = jsondecode(file("${path.module}/../shared-config/logging.json"))
  backup     = jsondecode(file("${path.module}/../shared-config/backup.json"))
  dns        = jsondecode(file("${path.module}/../shared-config/dns.json"))
  iam_policy = file("${path.module}/../policies/iam-policy.json")
  json_files = fileset("${path.module}/../shared-config", "*.json")
  other_json_files = fileset("${path.module}/../shared-config/other", "*.json")
}

# Using fileset() to find all YAML files outside of this project
locals {
  yaml_files = fileset("${path.module}/../shared-config", "*.yaml")
  tags       = file("${path.module}/../shared-config/tags.yaml")
  alerts     = file("${path.module}/../shared-config/alerts.yaml")
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = local.settings.instance_type

  tags = {
    Name        = "example-instance"
    Environment = local.settings.environment
  }
}

resource "aws_iam_policy" "example" {
  name   = "example-policy"
  policy = local.iam_policy
}

output "external_yaml_files" {
  description = "List of external YAML config files found via fileset"
  value       = local.yaml_files
}

output "external_json_files" {
  description = "List of externla json files found via a fileset"
  value       = local.json_files
}

output "other_external_json_files" {
  description = "List of other external json files found via a fileset"
  value       = local.other_json_files
}
