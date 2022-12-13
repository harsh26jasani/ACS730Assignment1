# Add output variables
output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "vpc_id" {
  value = aws_vpc.main1.id
}

#Output for Private IP
output "private_ip" {
  value = var.private_cidr_blocks
}

#Output for CIDR block 
output "prod_VPC_Cidr" {
  value = var.vpc_cidr
}
