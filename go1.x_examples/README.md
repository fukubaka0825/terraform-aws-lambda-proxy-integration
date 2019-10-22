# Simple go1.x example
## Creates an AWS Lambda function and its {proxy+} API gateway integration with S3 artifact
## usage
Decoupling app's deployment from infra's
```bash
// Put dummy code into S3 repo.
make deploy_dummy_code
// deploy infra
terraform init
terraform plan
terraform apply
// deploy app(lambda) 
make build_update

```