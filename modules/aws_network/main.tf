# Step 1 - Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
/*
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix       = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}

module "globalvars" {
  source = "/home/ec2-user/environment/modules/globalvars"
}
*/

# Local variables
locals {
  default_tags = merge(
    var.default_tags,
    { "Env" = var.env }
  )
  name_prefix = "${var.prefix}-${var.env}"
}



# Create a new VPC 
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  #enable_dns_hostnames = true
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-vpc"
    }
  )
}




# Adding public subnet in the default VPC 
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-public-subnet-${count.index}"
    }
  )
}




# Adding private subnetin the default VPC
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-private-subnet-${count.index}"
    }
  )
}




#Creating NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  #count = var.enable_nat_gateway ? 1 : 0
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-nat_gw"
    }
  )
}



# Creating elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  #count = var.enable_nat_gateway ? 1 : 0
  vpc   = true
  tags = {
    Name = "${local.name_prefix}-natgw"
  }
depends_on = [aws_internet_gateway.igw]
}





# Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  #count = var.enable_internet_gateway ? 1 : 0
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-igw"
    }
  )
}






# Route table to add default gateway pointing to Internet Gateway
resource "aws_route_table" "public_route_table" {
  #count = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    #gateway_id = aws_internet_gateway.igw[0].id
  }
  tags = {
    Name = "${local.name_prefix}-public_route_table"
  }
}



# Route table to add default gateway pointing to Internet Gateway (IGW)
resource "aws_route_table" "private_route_table" {
  #count = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
    #gateway_id = aws_nat_gateway.nat_gw[0].id
  }
   tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-private_route_table"
    }
  )
}


# Associate subnets with the custom route table
resource "aws_route_table_association" "public_route_table_association" {
  #count          = length(aws_subnet.public_subnet[*].id)
  #route_table_id = aws_route_table.public_route_table[0].id
  #subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet[0].id
}


# Associate subnets with the custom route table
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private_subnet[*].id)
  #  route_table_id = var.enable_nat_gateway ? aws_route_table.private_route_table[0].id : aws_route_table.private_route_table_without_ngw[0].id
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}

