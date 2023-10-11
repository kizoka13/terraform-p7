terraform {
  backend "s3" {
    bucket         = "my-kizoka-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"  # Replace with your desired region
    encrypt        = true
    dynamodb_table = "kizoka-table-lock"
  
  }
}
