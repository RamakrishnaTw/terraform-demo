variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "ec2_subnet_id" {
  type = list(string)
}

variable "ec2_sg" {
  type = string
}

variable "keypair_name" {
  type = string
  default = "mykeypair"
}
variable "pb_key" {
  type = string
}