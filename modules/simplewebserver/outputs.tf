#--------------------------------------------------------------------------------
# MODULE OUTPUTS
#--------------------------------------------------------------------------------
output "route53_FQDN" {
  value = "${aws_route53_record.webserver.name}"
}

output "publicip" {
  value = "${aws_route53_record.webserver.ip}"
}
