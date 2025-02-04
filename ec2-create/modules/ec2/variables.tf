variable "ami_id" {
  description = "The AMI ID to use for the instance"
}

variable "instance_type" {
  description = "The instance type to use"
}

variable "key_name" {
  description = "The name of the key pair"
}

variable "security_group_id" {
  description = "The ID of the security group"
}

variable "subnet_id" {
  description = "The ID of the subnet"
}

variable "instance_name" {
  description = "The name tag for the instance"
}