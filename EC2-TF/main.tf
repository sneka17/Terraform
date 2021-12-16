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
  access_key = xxxx
  secret_key = xxxx
  region = "ap-south-1"
}

resource "aws_vpc" "ownvpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    name = "${var.env}-vpc"
  }
}

module "myserver-subnet" {
  source = "./modules/subnet"
  vpc_id= aws_vpc.ownvpc.id
  subnet_cidr_block= var.subnet_cidr_block
  env=var.env
  az=var.az  
}

module "myserver-instance" {
  source = "./modules/webserver"
  vpc_id= aws_vpc.ownvpc.id
  subnet_id=module.myserver-subnet.subnet.id 
  env=var.env
  instance_type= var.instance_type
}


