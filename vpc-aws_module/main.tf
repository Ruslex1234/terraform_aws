module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"


  name = "rods-vpc"
  cidr = "10.42.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.42.1.0/24", "10.42.2.0/24"]
  public_subnets  = ["10.42.101.0/24", "10.42.102.0/24"]
  database_subnets = ["10.42.201.0/24", "10.42.202.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}
