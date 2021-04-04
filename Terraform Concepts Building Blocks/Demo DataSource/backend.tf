terraform {
    backend "s3" {
        bucket = "tf-state-98ftyxyz"
        key    = "development/terraform_state"
        region = "us-east-2"
    }
}