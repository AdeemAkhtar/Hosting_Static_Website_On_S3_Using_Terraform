# terraform {
#     backend "s3" {
#         bucket = "NAME_OF_YOUR_UNIQUE_S3_BUCKET_TO_STORE_TERRAFORM_REMOTE_BACKEND"
#         key    = "dev/terraform.tfstate"
#         region = "us-east-1"
#         encrypt = true
#         use_lockfile = true
#     }
# }