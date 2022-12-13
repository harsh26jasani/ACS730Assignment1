output "public_subnet_ids" {
  value = module.vpc-nonprod.public_subnet_ids
}
output "private_subnet_ids" {
  value = module.vpc-nonprod.private_subnet_ids
}

output "vpc_id" {
  value = module.vpc-nonprod.vpc_id
}

output "private_route_table" {
  value = module.vpc-nonprod.private_route_table
}


output "public_route_table" {
  value = module.vpc-nonprod.public_route_table
}

output "private_cidr_blocks" {
  value = module.vpc-nonprod.private_cidr_blocks
}

output "public_cidr_blocks" {
  value = module.vpc-nonprod.public_cidr_blocks
}

output "aws_nat_gateway" {
  value = module.vpc-nonprod.nat_gateway_id
}

output "aws_internet_gateway" {
  value = module.vpc-nonprod.aws_internet_gateway
}

output "aws_eip" {
  value = module.vpc-nonprod.aws_eip
}