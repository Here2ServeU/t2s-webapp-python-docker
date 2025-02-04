lock_table_name = "terraform-lock-table"
aws_region      = "us-east-1"
s3_bucket_name  = "my-terraform-backend-2025"
availability_zone = "us-east-1a"
key_name               = "web-app-key-pair"      # Key pair name for this environment
private_key_filename   = "web-app-key-pair.pem"  # Filename for the private key
rsa_bits               = 2048                   # RSA bit length for private key
