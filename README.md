# Terraform-demo

The Terraform-demo project is 3-tier application architecture infra code of API Gateway + Lambda + RDS(postgre).

<img width="567" alt="image" src="https://github.com/RamakrishnaTw/terraform-demo/assets/108268881/0d747b55-41e8-46a9-aea0-0e3b3f4a5d83">

## Pre-requisites

1. **[Installing-app-modules](#Installing-app-modules)**
2. **[Generating-ssh-keys](#Generating-ssh-keys)**
3. **[Managing_terraform_state](#Managing_terraform_state)**
4. **[Compressed_app_package](#Compressed_app_package)**
5. **[Input_configuration](#Input_configuration)**
6. **[Initialiting_Terraform](#Initialiting_Terraform)**


## Installing-app-modules
Navigate to app folder and install node modules.
```
    cd app
    npm install
```
## Generating-ssh-keys
To seed the data in RDS table initially, creating a Jump host(ec2) and below is key pair generation which will attached to instance.
```
    mkdir keys && cd $_
    ssh-keygen -f <KeyName>
```
Note: Generate in root project directory

## Managing_terraform_state
Managing Terraform state with S3 is necessary to store the state remotely in a secure and scalable manner, 
enabling versioning, collaboration, and seamless infrastructure management.

If you prefer to maintain a local state, we can skip this step. else Create a file named backend.tf and add the following content:
```
    touch backend.tf
```
```
    terraform {
  backend "s3" {
    bucket         = "<your_bucket_name>"
    key            = "terraform.tfstate"
    region         = "<your_aws_region>"
    dynamodb_table = "<your_dynamo_dbtable_name>"
  }
}
```
##  Compressed_app_package
To upload the app to Lambda as a deployment package, you need to zip the app. Follow these steps:
```
    cd app && zip -r app.zip . && mv app.zip ..
```

## Input_configuration
To input data variables, rename the "terraform.tfvars.template" file to "terraform.tfvars" and 
make necessary edits to the configuration as required.
```
    mv terraform.tfvars.template terraform.tfvars 
```
## Initialiting_Terraform
To initialize Terraform, run the following command: 
```
    terraform init
```
