/* required */
variable "apigw_name" {
  description = "Apigateway's name"
}
variable "s3_bucket" {
  description = "S3 bucket's name where lambda app artifact exists"
}
variable "s3_key" {
  description = "S3 object key's name where lambda app artifact exists"
}
variable "function_name" {
  description = "Lambda function's name"
}
variable "lambda_role" {
  description = "Lambda function's execution role"
}
/* optional */
variable "http_method" {
  description = "API Gateway's http method"
  default     = "ANY"
}
variable "integration_http_method" {
  description = "Integration http method"
  default     = "POST"
}
variable "stage_name" {
  description = "Stage name"
  default     = "test"
}
variable "handler" {
  description = "Lambda function's handler name"
  default     = "main"
}
variable "timeout" {
  description = "The timeout of the lambda function"
  default     = 200
}
variable "memory_size" {
  description = "The memory size of the lambda function"
  default     = 512
}
variable "runtime" {
  description = "The runtime of the lambda function"
  default     = "go1.x"
}
variable "env_vars" {
  description = "The environment variables of the lambda function"
  type        = map(string)
  default = {
    ENV = "test"
  }
}

variable "subnet_ids" {
  description = "If you want to use vpc lambda,required"
  default     = null
}

variable "security_group_ids" {
  description = "If you want to use vpc lambda,required"
  default     = null
}