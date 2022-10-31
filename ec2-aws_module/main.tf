module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"
  name = "single-instance"

  ami                    = "ami-09d3b3274b6c5d4aa"
  instance_type          = "t2.micro"
  key_name               = "mpulse"
  vpc_security_group_ids = [module.vpc.aws_db_subnet_group.database[0]]
  #vpc_security_group_ids = [var.default_security_group_id]
  subnet_id              = ["subnet-eddcdzz4"]  
  
}


