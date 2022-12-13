# Step 1 - Define the provider
provider "aws" {
  alias  = "central"
  region = "us-east-1"
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}



module "globalvars" {
  source = "../../../modules/globalvars"
}


locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix       = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}


# Create a new VPC 
resource "aws_vpc" "main1" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = merge(
    var.default_tags, {
      Name = "${local.name_prefix}-vpc"
    }
  )
}

# Add provisioning of the private subnetin the default VPC
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.main1.id
  cidr_block        = var.private_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-private-subnet-${count.index}"
    }
  )
}
