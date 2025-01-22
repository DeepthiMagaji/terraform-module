terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  region = "eu-central-1"
}

module "compute" {
  source               = "./module/compute"
  ami                  = "ami-07eef52105e8a2059"
  instance_type        = "t2.micro"
  tag_name             = "ExampleAppServerInstance"
  sg                   = module.security.webserver_sg
  iam_instance_profile = module.iam.s3_profile
  user_data            = file("./userdata.tpl")
}

module "security" {
  source = "./module/security"
}

module "iam" {
  source                 = "./module/iam"
  role_name              = "s3-list-bucket"
  policy_name            = "s3-list-bucket"
  instance_profile_name  = "s3-list-bucket"
  path                   = "/"
  iam_policy_description = "s3 policy for ec2 to list role"
  iam_policy             = file("./s3-list-bucket-policy.tpl")
  assume_role_policy     = file("./s3-list-bucket-trusted-identity.tpl")
}

module "s3" {
  source        = "./module/s3"
  bucket_name   = "devinslevelupdevoteam"
  acl           = "private"
  object_key    = "LUIT"
  object_source = "/dev/null"
}