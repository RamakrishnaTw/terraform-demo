variable "rds_subnet_group" {
  type = string
  default = "rdb-subnet-group"
}

variable "identifier" {
  type = string
  default = "library-db"
}

variable "engine" {
  type = string
  default = "postgres"
}

variable "engine_version" {
  type = string
  default = "14.7"
}

variable "instance_class" {
  type = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type = string
  default = "20"
}

variable "db_name" {
  type = string
  default = "librarydb"
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "parameter_group_name" {
  type = string
  default = "default.postgres14"
}

variable "private_subnet_ids" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "rds_sg" {
  type = string
}