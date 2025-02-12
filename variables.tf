variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "web_app_ami" {
  description = "AMI ID for web app instance"
  type        = string
}

variable "database_ami" {
  description = "AMI ID for database instance"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "private_key_path" {
  description = "Path to private key file for SSH"
  type        = string
}

variable "db_volume_id" {
  description = "ID of EBS volume for database"
  type        = string
}

variable "user_name" {
  description = "User name for ssh connection"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
}

variable "db_user" {
  description = "Database user"
  type        = string
}

variable "flask_secret" {
  description = "Secret key for Flask app"
  type        = string
}