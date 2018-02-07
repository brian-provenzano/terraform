# output "jenkinsslave_dnsname" {
#   value = "${module.jenkins_noasg.jenkinsslave_route53_FQDN}"
# }
output "jenkinsmaster_dnsname" {
  value = "${module.jenkins_noasg.jenkinsmaster_route53_FQDN}"
}