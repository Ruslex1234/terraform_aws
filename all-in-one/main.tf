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

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"
  for_each = {
     "private" = {
    "ec2_name" : "private-ec2",
    "subnet" : module.vpc.private_subnets[0],
    "ami" : "ami-09d3b3274b6c5d4aa",
    "keypair" : "mpulse",
    "type" : "t2.micro"
  }
    "public" = {
    "ec2_name" : "public-ec2",
    "subnet" : module.vpc.public_subnets[0],
    "ami" : "ami-09d3b3274b6c5d4aa",
    "keypair" : "mpulse",
    "type" : "t2.micro"
  }
  }
  
  #for_each = var.configuration

  name = each.value.ec2_name

  ami                    = each.value.ami
  instance_type          = each.value.type
  key_name               = each.value.keypair
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = each.value.subnet
}

/*module "rds_db_subnet_group" {
  source  = "terraform-aws-modules/rds/aws//modules/db_subnet_group"
  version = "5.1.0"
  subnet_ids = module.vpc.database_subnets
}*/

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.1.0"

  family = "postgres13"
  identifier = "rodsdb"
  db_name  = "rodsdb"
  username = "rodney"
  allocated_storage = 100
  engine            = "postgres"
  engine_version    = "13.7"
  instance_class    = "db.t4g.micro"
  db_subnet_group_name = "rods-vpc"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_ids = module.vpc.database_subnets
}

module "stop_ec2_instance" {
  source                         = "diodonfrost/lambda-scheduler-stop-start/aws"
  name                           = "ec2_stop"
  custom_iam_role_arn = "arn:aws:iam::277924740697:role/adminec2"
  cloudwatch_schedule_expression = "cron(0 1 * * ? *)"
  schedule_action                = "stop"
  ec2_schedule                   = "true"
  scheduler_tag                  = {
    key   = "tostop"
    value = "true"
  }
}

module "start_ec2_instance" {
  source                         = "diodonfrost/lambda-scheduler-stop-start/aws"
  name                           = "ec2_start"
  custom_iam_role_arn = "arn:aws:iam::277924740697:role/adminec2"
  cloudwatch_schedule_expression = "cron(0 15 * * ? *)"
  schedule_action                = "start"
  ec2_schedule                   = "true"
  scheduler_tag                  = {
    key   = "tostop"
    value = "true"
  }
}