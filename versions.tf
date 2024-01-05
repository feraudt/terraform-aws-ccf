terraform {
  # TEMP
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.6.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
  }

  required_version = ">= 0.13"
}
