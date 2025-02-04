variable "lock_table_name" {
  description = "The name of the DynamoDB table for Terraform state locking."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for storing Terraform state."
  type        = string
}

variable "availability_zone" {
  description = "The availability zone to use for the EC2 instance."
  type = string 
}

variable "key_name" {
  description = "Name of the key pair to create"
  type        = string
}

variable "private_key_filename" {
  description = "Filename for the private key"
  type        = string
}

variable "rsa_bits" {
  description = "Number of RSA bits for the private key"
  type        = number
}
