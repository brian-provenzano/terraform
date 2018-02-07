# https://www.terraform.io/docs/configuration/terraform.html
terraform {
  required_version = "~> 0.9"
}

# ------------------------------------------------------------------------------
# CONFIGURE AWS CONNECTION (PROVIDER)
# ------------------------------------------------------------------------------
provider "aws" {
  region = "${var.region_uswest1}"
}

# ROUTE53 -- TODO put this global... just playing now
data "aws_route53_zone" "selected" {
  name = "thenuclei.org."
  private_zone = false
}

# ------------------------------------------------------------------------------
# IAM - POLICIES, ROLES, GROUPS, USERS, etc.
# TODO - move IAM to a base env or module since it is global to all envs
# ------------------------------------------------------------------------------

# jenkins master server :
# - function: use IAM role to allow server to reassign its DNS for public access

# # Role 
# resource "aws_iam_role" "ec2_rt53_access" {
#   name = "EC2Route53Access"
#   assume_role_policy = "${file("../global/files/iam/roles/assume-role-policy-ec2.txt")}"
# }
# # Policy for route53
# resource "aws_iam_role_policy" "AllowEC2ManageEIP" {
#   name = "AllowEC2ManageRt53"
#   role = "${aws_iam_role.ec2_rt53_access.name}"
#   policy = "${file("../global/files/iam/roles/policy-allowmanage-records-rt53.txt")}"
# }
# # Instance profile to attach to the instances
# resource "aws_iam_instance_profile" "EC2ManageRt53" {
#   name  = "EC2ManageRt53"
#   role = "${aws_iam_role.ec2_rt53_access.name}"
# }




# ------------------------------------------------------------------------------
# MODULES
# ------------------------------------------------------------------------------

# -- CREATE vpc, subnets, security groups, eips, network ACLs etc.
module "networking" {
  source = "../modules/networking"
  
  #module inputs
  environment = "${var.environment}"
  vpc_name = "${var.vpc_name}"
  vpc_cidr = "${var.vpc_cidr}"
  publicsubnet_cidrs = ["${var.publicsubnet_one_cidr}","${var.publicsubnet_two_cidr}"]
  availability_zones = ["${var.azs_uswest1}"]
  enable_bastion = false
  
  tags { 
    # Name tag is handled internally
    "Terraform" = "true"
    "Role" = "networking"
    "Department" = "development"
    "Environment" = "${var.environment}"
  }
}

# -- CREATE jenkins servers
module "jenkins_noasg" {
  source = "../modules/jenkins_noasg"

  #module inputs
  environment = "${var.environment}"
  route53_zoneid = "${data.aws_route53_zone.selected.zone_id}"
  route53_zonename = "${data.aws_route53_zone.selected.name}"
  subnet = "${module.networking.public_subnets[0]}"
  keyname = "${var.key_name_uswest1}"
  keyfile = "${var.key_file_uswest1}"
  mastername = "${var.mastername}"
  #master_instanceprofile = "${aws_iam_instance_profile.EC2ManageRt53.id}"
  master_instanceuser = "centos"
  master_instancetype = "t2.micro"
  master_ami = "${lookup(var.centos7_amis, var.region_uswest1)}"
  master_userdata = "${data.template_file.jenkinsmaster_userdata.rendered}"
  master_securitygroups = ["${module.networking.jenkinsmaster_security_group_id}"]
  slavename = "${var.slavename}"
  slave_instanceuser = "centos"
  slave_instancetype = "t2.micro"
  slave_ami = "${lookup(var.centos7_amis, var.region_uswest1)}"
  slave_userdata = "${data.template_file.jenkinsslave_userdata.rendered}"
  slave_securitygroups = ["${module.networking.jenkinsslave_security_group_id}"]
  
  tags { 
    # Name tag is handled internally
    "Terraform" = "true"
    "Role" = "CI-CD"
    "Application" = "jenkins"
    "Department" = "development"
    "Environment" = "${var.environment}"
  }
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# !!! END OF CONFIG - everything below this is either templates or old !!!
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~