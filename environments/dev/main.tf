provider "aws" {
  region = "ap-south-1"
}

module "network" {
  source      = "../../modules/network"
  vpc_cidr    = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
}

module "compute" {
  source          = "../../modules/compute"
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = module.network.subnet_id
  sg_id           = module.network.sg_id
}