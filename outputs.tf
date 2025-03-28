output "webapp_public_ip" {
  description = "Public IP addresses of the WebApp instances"
  value       = [for instance in aws_instance.web_app_instance : instance.public_ip]
}

output "api_cname" {
  description = "CNAME of the API"
  value       = aws_route53_record.api_cname.fqdn
}