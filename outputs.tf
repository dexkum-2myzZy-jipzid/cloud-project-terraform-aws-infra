output "webapp_public_ip" {
  description = "Public IP address of the WebApp instance"
  value       = aws_instance.web_app_instance.public_ip
}