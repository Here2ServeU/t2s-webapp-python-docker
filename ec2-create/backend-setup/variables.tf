variable "aws_region" {
  description = "The AWS region to deploy resources"
}

variable "backend_bucket_name" {
  description = "The name of the S3 bucket for the backend"
}

variable "lock_table_name" {
  description = "The name of the DynamoDB table for state locking"
}
