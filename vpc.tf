terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.65.0"
    }
  }
}

provider "aws" {
  # Configuration options
  access_key = "AKIAXK4SNNEIW3UMGK75"
  secret_key = "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"
  region = "us-west-2"
}

variable "vpc_cidr_block" {}
variable "private_subnets_cidr_blocks" {}
variable "public_subnets_cidr_blocks" {}

data "aws_availability_zones" "available" {
  
}


module "myapp-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "myapp-vpc"
  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets_cidr_blocks
  public_subnets  = var.public_subnets_cidr_blocks

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }
  public_subnet_tags= {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared" 
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared" 
    "kubernetes.io/role/internal-elb" = 1 
  }
}