#--------------------------------------------------------------------------------
# MODULE INPUTS (TF equiv of arguments, params, whatever)
#--------------------------------------------------------------------------------
variable "environment" {
  description = "The current env to build for - (be careful here, changing this will cycle the ASG, LC, etc!!)"
}

variable "webservername" {
  description = "The name to use for the web server.  Note changing this will cycle the instance!!"
}

variable "tags" {
  description = "The tags to use for the resources"
}

variable "route53_zoneid" {
  description = "The current env to build for"
}

variable "route53_zonename" {
  description = "The current env to build for"
}

variable "instanceuser" {
  description = "The current env to build for"
}

variable "keyname" {
  description = "The current env to build for"
}

variable "keyfile" {
  description = "The current env to build for"
}

variable "instancetype" {
  description = "The current env to build for"
}

variable "imageid" {
  description = "The current env to build for"
}

variable "securitygroups" {
  type        = "list"
  description = "The current env to build for"
}

variable "userdata" {
  description = "The current env to build for"
}
