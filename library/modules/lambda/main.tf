##################### - Lambda  - ###############################

resource "aws_lambda_function" "lambda_function" {
  function_name    = var.function_name
  handler          = var.handler
  runtime          = var.runtime
  role             = aws_iam_role.lambda_role.arn
  filename         = "${path.cwd}/../${var.filename}"  


  vpc_config {
    subnet_ids         =  slice(var.private_subnet_ids, 0, 2)
    security_group_ids = [var.lambda_sg]
  }

  environment {
    variables = {
      DB_USER     = var.username
      DB_PASSWORD = var.password
      DB_HOST     = var.host
      DB_NAME     = var.db_name
      DB_PORT     = 5432
    }
  }
}


resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  name   = "AWSLambdaRole"
  role   = aws_iam_role.lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction",
        "lambda:ListFunctions"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "vpcexecutionpolicy" {
  role       = aws_iam_role.lambda_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "secretReadOnly" {
  role       = aws_iam_role.lambda_role.id
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

###################### AWS Secret Manager #########################

# resource "aws_secretsmanager_secret" "R-db-credentials" {
#   name = "R-credentials"
# }

# resource "aws_secretsmanager_secret_version" "database_credentials_version" {
#   secret_id     = aws_secretsmanager_secret.R-db-credentials.id
#   secret_string = <<EOF
# {
#   "username": ${aws_db_instance.library-db.username},
#   "password": ${aws_db_instance.library-db.password},
#   "host": ${aws_db_instance.library-db.address},
#   "dbname": ${aws_db_instance.library-db.db_name}
# }
# EOF
# }
