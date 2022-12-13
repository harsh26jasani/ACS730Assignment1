# Instance type
variable "instance_type" {
  default = {
    "prod"    = "t3.medium"
    "test"    = "t3.micro"
    "staging" = "t2.micro"
    "nonprod" = "t2.micro"
  }
  description = "Instance type"
  type        = map(string)
}

# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Harsh"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags is appliad to all the AWS resources"
}

# Prefix to identify resources
variable "prefix" {
  default     = "ACS730Assignment1"
  type        = string
  description = "Name prefix"
}


# Variable to signal the current environment 
variable "env" {
  default     = "nonprod"
  type        = string
  description = "Deployment Environment"
}




