variable "ami" {
  description = "ami for our instance"
  type        = string
}

variable "instance_type" {
  description = "the instance type of our instance"
  type        = string
}

#variable "sg" {
#  description = "sd that allows http/ssh"
#}

variable "tag_name" {
  description = "name of the tag"
  type        = string
}

variable "user_data" {
  description = "userdata that will install webserver bash script"
  type        = string
}

#variable "iam_instance_profile" {
#  description = "iam instance profile for the ec2 instance"
#}

variable "role_name" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "path" {
  type = string
}

variable "iam_policy" {
  type = string

}

variable "assume_role_policy" {
  type = string
}

variable "iam_policy_description" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "acl" {
  type = string
}

variable "object_key" {
  type = string
}

variable "object_source" {
  type = string
}

variable "region" {
  type = string
}