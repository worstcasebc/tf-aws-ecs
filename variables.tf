variable "AWS_REGION" {
  default = "eu-central-1"
}

variable "public_subnets" {
  type    = list
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  type    = list
  default = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "http" "icanhazip" {
  url = "http://icanhazip.com"
}