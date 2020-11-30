locals {
  environment = "dev"
}

module "vpc" {
  source = "github.com/worstcasebc/terraform-aws-vpc"

  name       = var.name
  cidr_block = var.cidr_block

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  bastion_host = true
}