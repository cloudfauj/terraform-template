locals {
  common_tags = {
    manager = "cloudfauj"
  }
}

resource "aws_route53_zone" "dns_manager" {
  name          = var.name
  tags          = local.common_tags
  force_destroy = true
  comment       = "Public Hosted Zone for ${var.name} managed by Cloudfauj"
}

resource "aws_acm_certificate" "primary_wildcard_cert" {
  domain_name               = var.name
  subject_alternative_names = ["*.${var.name}"]
  validation_method         = "DNS"
  tags                      = local.common_tags
}

// Add the DNS validation records to the Hosted zone.
// Note that this alone is not enough to validate the ACM cert.
// The NS records of the main R53 zone must be configured with the domain
// provider manually by the user.
// After that, ACM will be able to validate & issue the certificate.
resource "aws_route53_record" "acm_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.primary_wildcard_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true

  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = aws_route53_zone.dns_manager.zone_id
}
