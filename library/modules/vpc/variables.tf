variable "vpc_tag" {
  type = string
  default = "R-vpc"
}

variable "vpc_igw_tag" {
  type = string
  default = "R-igw"
}

variable "vpc_eip_tag" {
  type = string
  default = "R-EIP"
}

variable "nat_tag" {
  type = string
  default = "R-nat"
}

variable "public_route_tag" {
  type = string
  default = "R-public-1"
}

variable "private_route_tag" {
  type = string
  default = "R-private-1"
}


variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_ids" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_ids" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
}

