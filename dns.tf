data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "api_cname" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "api"
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.api_nlb.dns_name]
}