variable "project_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "awsbootstrap-tf"
}

variable "instance_ami" {
  description = "AMI for EC2 instance"
  type        = string
  default     = "ami-0cff7528ff583bf9a"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

#variable "resource_tags" {
#  description = "Tags to set for all resources"
#  type        = map(string)
#  default     = {
#    project     = "awsbootstrap-terraform",
#    environment = "dev"
#  }
#}
