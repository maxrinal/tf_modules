# see https://github.com/hashicorp/terraform
terraform {
  required_providers {
    # see https://registry.terraform.io/providers/hashicorp/template
    template = {
      source = "hashicorp/template"
    }
  }
}

