output "web_app_public_ip" {
  description = "Public IP address of the WebApp instance"
  value       = aws_instance.web_app_instance.public_ip
}

output "database_private_ip" {
  description = "Private IP address of the Database instance"
  value       = aws_instance.database_instance.private_ip
}

output "database_instance_id" {
  description = "Instance ID of the Database instance"
  value       = aws_instance.database_instance.id
}