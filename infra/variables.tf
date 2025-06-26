variable "region" { default = "eu-west-1" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "public_subnet_cidrs" { default = ["10.0.1.0/24", "10.0.2.0/24"] }
variable "private_subnet_cidrs" { default = ["10.0.101.0/24", "10.0.102.0/24"] }
variable "availability_zones" { default = ["eu-west-1a", "eu-west-1b"] }
variable "ami_id" { default = "ami-01f23391a59163da9" } # Ubuntu Server 24.04 LTS
variable "key_name" { default = "bastion_ssh_key" }
