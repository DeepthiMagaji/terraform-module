region = "eu-central-1"

ami           = "ami-07eef52105e8a2059"
instance_type = "t2.micro"
tag_name      = "ExampleAppServerInstance"
user_data     = "../userdata.tpl"

role_name              = "s3-list-bucket"
policy_name            = "s3-list-bucket"
instance_profile_name  = "s3-list-bucket"
path                   = "/"
iam_policy_description = "s3 policy for ec2 to list role"
iam_policy             = "../s3-list-bucket-policy.tpl"
assume_role_policy     = "../s3-list-bucket-trusted-identity.tpl"

bucket_name   = "devinslevelupdevoteam"
acl           = "private"
object_key    = "LUIT"
object_source = "/dev/null"