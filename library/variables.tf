variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "availability_zones" {
}

variable "vpc_cidr" {
}

variable "public_subnet_ids" {
}

variable "private_subnet_ids" {
}

variable "AMIS" {
  type = map(any)
}

variable "identifier" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = string
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "function_name" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "apiGateway_name" {
  type    = string
  default = "My-api_gatway"
}

variable "api1_resource" {
  type = string
}
variable "api2_resource" {
  type = string
}

variable "http_method" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "pb_key" {
  type = string
}

variable "My_ip" {
  type = string
}

variable "All_ip" {
  type = string
}

variable "filename" {
  type = string
}


