resource "aws_api_gateway_rest_api" "library" {
  name        = var.apiGateway_name
  description = "REST API 1"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "api1_resource" {
  rest_api_id = aws_api_gateway_rest_api.library.id
  parent_id   = aws_api_gateway_rest_api.library.root_resource_id
  path_part   = var.api1_resource
}

resource "aws_api_gateway_method" "api1_method" {
  rest_api_id   = aws_api_gateway_rest_api.library.id
  resource_id   = aws_api_gateway_resource.api1_resource.id
  http_method   = var.api1_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api1_integration" {
  rest_api_id             = aws_api_gateway_rest_api.library.id
  resource_id             = aws_api_gateway_resource.api1_resource.id
  http_method             = aws_api_gateway_method.api1_method.http_method
  type                    = var.type
  integration_http_method = var.api1_method
  uri                     = var.lambda_arn

  depends_on = [ aws_api_gateway_resource.api1_resource, aws_api_gateway_method.api1_method]
}

resource "aws_api_gateway_deployment" "api1_deployment" {
  depends_on    = [aws_lambda_permission.api1_gateway_permission]
  rest_api_id   = aws_api_gateway_rest_api.library.id
  stage_name    = var.stage_name
}

resource "aws_lambda_permission" "api1_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.library.execution_arn}/*"
  //source_arn    = "arn:aws:lambda:${var.AWS_REGION}:${var.ACCOUNT_ID}:${aws_api_gateway_rest_api.api1.id}/*/${aws_api_gateway_method.api1_method.http_method}${aws_api_gateway_resource.api1_resource.path}"
  depends_on = [ aws_api_gateway_integration.api1_integration ]
}


resource "aws_api_gateway_resource" "api2_resource" {
  rest_api_id = aws_api_gateway_rest_api.library.id
  parent_id   = aws_api_gateway_rest_api.library.root_resource_id
  path_part   = var.api2_resource
}

resource "aws_api_gateway_method" "api2_method" {
  rest_api_id   = aws_api_gateway_rest_api.library.id
  resource_id   = aws_api_gateway_resource.api2_resource.id
  http_method   = var.api2_method
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "api2_integration" {
  rest_api_id             = aws_api_gateway_rest_api.library.id
  resource_id             = aws_api_gateway_resource.api2_resource.id
  http_method             = aws_api_gateway_method.api2_method.http_method
  type                    = var.type
  integration_http_method = var.api2_method
  uri                     = var.lambda_arn
  request_parameters =  {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
 depends_on = [ aws_api_gateway_resource.api2_resource,aws_api_gateway_method.api2_method ]
}

resource "aws_api_gateway_deployment" "api2_deployment" {
  depends_on    = [aws_lambda_permission.api2_gateway_permission]
  rest_api_id   = aws_api_gateway_rest_api.library.id
  stage_name    = var.stage_name
  
}


resource "aws_lambda_permission" "api2_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.library.execution_arn}/*"
  //source_arn    = "arn:aws:lambda:${var.AWS_REGION}:${var.ACCOUNT_ID}:${aws_api_gateway_rest_api.api1.id}/*/${aws_api_gateway_method.api2_method.http_method}${aws_api_gateway_resource.api2_resource.path}"
  depends_on = [ aws_api_gateway_integration.api2_integration ]
}



