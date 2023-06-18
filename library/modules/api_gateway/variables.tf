 variable "apiGateway_name" {
  type = string
  default = "My-api_gatway"
}

 variable "api1_resource" {
  type = string
}

 variable "api1_method" {
  type = string
}

 variable "stage_name" {
  type = string
  default = "Prod"
}

 variable "type" {
  type = string
  default = "AWS_PROXY"
}

variable "lambda_arn" {
  type = string
}

variable "lambda_function_name" {
  type = string
}

variable "api2_resource" {
  type = string
}

 variable "api2_method" {
  type = string
}
