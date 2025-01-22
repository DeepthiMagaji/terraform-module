variable "ami" {
  description = "ami for our instance"
}

variable "instance_type" {
  description = "the instance type of our instance"
}

variable "sg" {
  description = "sd that allows http/ssh"
}

variable "tag_name" {
  description = "name of the tag"
}

variable "user_data" {
  description = "userdata that will install webserver bash script"
}

variable "iam_instance_profile" {
  description = "iam instance profile for the ec2 instance"
}