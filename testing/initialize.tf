#-----
# initialize the remote state with these values 
# (only need to run this once via terraform init)
#-----
terraform {
  backend "s3" {
    bucket = "terraform-state.thenuclei.org"
    key    = "testing.tfstate"
    region = "us-west-1"
    encrypt = "true"
    profile = "default"
    dynamodb_table = "terraform-locker"
  }
}
