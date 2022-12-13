output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}


output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}


# Output variables for Nat Gate Way
output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}

# Output variables for Internet Gateway
output "aws_internet_gateway" {
  value = aws_internet_gateway.igw.id
}

# Output variables for Elastic IP
output "aws_eip" {
  value = aws_eip.nat_eip.id
}



# Output variables for Private Route
output "private_route_table" {
  value = aws_route_table.private_route_table.id
}

# Output variables for Public Route Table
output "public_route_table" {
  value = aws_route_table.private_route_table.id
}


/*
output "private_route_table" {
  value = length(aws_route_table.private_route_table) > 0  ? aws_route_table.private_route_table[0].id : length(aws_route_table.private_route_table_without_ngw) > 0 ? aws_route_table.private_route_table_without_ngw[0].id : ""
}


output "public_route_table" {
   value = length(aws_route_table.public_route_table) > 0  ? aws_route_table.public_route_table[0].id : "" 
}
*/


# Output variables for Public Cidr Block
output "public_cidr_blocks" {
  value = var.public_cidr_blocks
}

# Output variables for Private CIDR block 
output "private_cidr_blocks" {
  value = var.private_cidr_blocks
}