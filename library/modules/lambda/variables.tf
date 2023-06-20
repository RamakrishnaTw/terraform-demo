variable "function_name" {
   type = string
  default = "default_lambda"
}

variable "handler" {
   type = string
  default = "index.handler"
}

variable "runtime" {
   type = string
 default = "nodejs14.x"
}

variable "filename" {
   type = string
}

variable "private_subnet_ids" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "lambda_sg"{
  type = string
}
