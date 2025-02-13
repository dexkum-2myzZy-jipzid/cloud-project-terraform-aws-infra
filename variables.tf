variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "webapp_ami_id" {
  description = "AMI ID for web app instance"
  type        = string
}

variable "mysql_ami_id" {
  description = "AMI ID for database instance"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "cyse6225-assignment2"
}

# variable "private_key_path" {
#   description = "Path to private key file for SSH"
#   type        = string
# }

variable "db_volume_id" {
  description = "ID of EBS volume for database"
  type        = string
  default     = "vol-0b3ee064272bb7099"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "recommend"
}

variable "database_password" {
  description = "Database password"
  type        = string
}

variable "database_username" {
  description = "Database user"
  type        = string
}

variable "webapp_secret_key" {
  description = "Secret key for Flask app"
  type        = string
}