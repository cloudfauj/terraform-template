output "zone_id" {
  value = aws_route53_zone.dns_manager.zone_id
}

output "name_servers" {
  value = aws_route53_zone.dns_manager.name_servers
}

output "ssl_cert_arn" {
  value = aws_acm_certificate.primary_wildcard_cert.arn
}