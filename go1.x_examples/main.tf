/* configure */
terraform {
  required_version = "0.12.0"
  backend "s3" {}
}

provider "aws" {
  version = "2.23.0"
  region  = "ap-northeast-1"
}


module "sample_api" {
  source  = "fukubaka0825/lambda-proxy-integration/aws"
  version = "1.0.0"

  apigw_name    = "sample-api"
  function_name = "sample-api"
  lambda_role   = module.lambda_role.iam_role_arn

  // The repo's name and object key where source code artifact exists
  s3_bucket = data.terraform_remote_state.storage.outputs.s3_serverless_app_bucket.name
  s3_key    = "lambda/sample.zip"

  // If you want to use vpc lambda,required
  security_group_ids = [module.http_sg.security_group_id]
  subnet_ids         = data.terraform_remote_state.network.outputs.subnet_ids
}

/* sg */
module "http_sg" {
  source         = "modules/sg"
  name           = "laboon-prod-http-sg"
  vpc_id         = "vpc-a1f15dc4"
  ingress_config = local.ad_http_ingress_config

}

/* lambda role */
module "lambda_role" {
  source     = "modules/iam_role"
  role_name  = "sample-lambda-role"
  identifier = "lambda.amazonaws.com"
  policies = [
    {
      name   = "lambda-policy"
      policy = data.aws_iam_policy_document.laboon_policy.json
    }
  ]
}

data "aws_iam_policy_document" "laboon_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface"
    ]
  }
}


data "terraform_remote_state" "storage" {
  backend = "s3"

  config = {
    bucket = "tf-playground"
    key    = "storage/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-playground"
    key    = "network/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

/* locals */
locals {
  /* sg required */
  ad_http_ingress_config = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      cidr_blocks              = ["0.0.0.0/0"]
      source_security_group_id = null
    }
  ]
}


