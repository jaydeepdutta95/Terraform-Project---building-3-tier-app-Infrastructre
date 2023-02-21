# Author    : Jaydeep Dutta
#LinkedIn   : www.linkedin.com/in/jaydeepdutta95
#GitHub     : https://github.com/jaydeepdutta95
#Hashnode   : https://jaydeep2022.hashnode.dev/
########################################################

variable "cidr" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "az" {
  type    = list(any)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "ec2_ami" {
  type    = string
  default = "ami-08df646e18b182346"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"

}