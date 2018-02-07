#environment|management
# !!! leave line above as is - do not delete (used in our tfwrapper) !!!

###############
# VARIABLES - management
###############

variable "environment" {
  description = "Name of environment (testing, development, production, etc)"
  default = "management"
}

# -------Jenkins
variable "mastername" {
  description = "The name of the jenkins master"
  default = "jenkins"
}
variable "slavename" {
  description = "The name of the jenkinsslave"
  default = "jenkins-slave"
}
#templates for instance master
data "template_file" "jenkinsmaster_userdata" {
  template = "${file("../global/files/bootstraps/config-jenkinsmaster.sh")}"
  vars {
    thehostname = "${var.mastername}"
  }
}
#templates for instance slave
data "template_file" "jenkinsslave_userdata" {
  template = "${file("../global/files/bootstraps/config-jenkinsslave.sh")}"
    vars {
    thehostname = "${var.slavename}"
  }
}


# ---------------------
# Networking 
# (Management specific env)
# ---------------------
variable "vpc_name" {
  description = "The name of the VPC"
  default = "mainvpc"
}
# this range chosen in case we peer with others
variable "vpc_cidr" {
  description = "The CIDR range for the VPC"
  default = "10.101.0.0/16"
}
variable "publicsubnet_one_cidr" {
  description = "The CIDR of public subnet one"
  default = "10.101.1.0/24"
}
variable "publicsubnet_two_cidr" {
  description = "The CIDR of public subnet two"
  default = "10.101.2.0/24"
}
variable "privatesubnet_one_cidr" {
  description = "The CIDR of private subnet one"
  default = "10.101.10.0/24"
}
variable "privatesubnet_two_cidr" {
  description = "The CIDR of private subnet two"
  default = "10.101.20.0/24"
}
variable "private_db_subnet_one_cidr" {
  description = "The CIDR of private subnet one for databases"
  default = "10.101.100.0/24"
}
variable "private_db_subnet_two_cidr" {
  description = "The CIDR of private subnet two for databases"
  default = "10.101.200.0/24"
}


# --------------------------------------------------------------------------------------
# REGIONS (TODO - refactor to global level or something..this is crap)
# --------------------------------------------------------------------------------------

# ---------------------
# US-WEST-1 (CA) region
# ---------------------
# region 
variable "region_uswest1" {
  description = "uswest1 region"
  default = "us-west-1"
}
# Declare the data source
#data "aws_availability_zones" "available" {}

#AZs for this region
variable "azs_uswest1" {
  type = "list"
  description = "uswest1 availability zones"
  default = ["us-west-1a","us-west-1b"]
  #default = ["${data.aws_availability_zones.available.names}"]
}

# ---Canned AMIs
# TODO - prep a script that automates this to always get latest AMIs for each distro

# Ubuntu 16.04 LTS
variable "ubuntu1604_amis" {
  type = "map"
  default = {
    us-east-2 = "ami-8b92b4ee"
    us-west-1 = "ami-73f7da13"
    us-west-2 = "ami-835b4efa"
  }
}
# Amazon Linux
variable "amzlinux_amis" {
  default = {
    type = "map"
    us-east-2 = "ami-8a7859ef"
    us-west-1 = "ami-327f5352"
    us-west-2 = "ami-6df1e514"
  }
}
# CentOS 7 - this is a marketplace AMI (requires presign agreement)
variable "centos7_amis" {
  default = {
    type = "map"
    us-east-2 = "ami-18f8df7d"
    us-west-1 = "ami-f5d7f195"
    us-west-2 = "ami-f4533694"
  }
}
# Keys
# <<redacted>>

# ---Our Custom AMIs via Packer
# TODO


# ---------------------
# US-WEST-2 (OR) region
# ---------------------
# region 
variable "region_uswest2" {
  description = "uswest2 region"
  default = "us-west-2"
}
# Keys
# <<redacted>>


# ---------------------
# US-EAST-2 (OH) region
# ---------------------
# region 
variable "region_useast2" {
  description = "useast2 region"
  default = "us-east-2"
}
# Keys
# <<redacted>>