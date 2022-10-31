output "dbsubnet" {
  value = module.vpc.database_subnets[0]
}

output "privsubnet" {
  value = module.vpc.private_subnets[0]
}

output "pubsubnet" {
  value = module.vpc.public_subnets[0]
}
output "default_sg" {
  value = module.vpc.default_security_group_id
}
