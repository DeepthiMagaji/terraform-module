terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  region = var.region
}

module "compute" {
  source               = "../module/compute"
  ami                  = var.ami
  instance_type        = var.instance_type
  tag_name             = var.tag_name
  sg                   = module.security.webserver_sg
  iam_instance_profile = module.iam.s3_profile
  user_data            = var.user_data
}

module "security" {
  source = "../module/security"
}

module "iam" {
  source                 = "../module/iam"
  role_name              = var.role_name
  policy_name            = var.policy_name
  instance_profile_name  = var.instance_profile_name
  path                   = var.path
  iam_policy_description = var.iam_policy_description
  iam_policy             = var.iam_policy
  assume_role_policy     = var.assume_role_policy
}

module "s3" {
  source        = "../module/s3"
  bucket_name   = var.bucket_name
  acl           = var.acl
  object_key    = var.object_key
  object_source = var.object_source
}