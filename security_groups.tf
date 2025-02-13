# Web application security group
resource "aws_security_group" "web_app_sg" {
  name        = "WebAppSecurityGroup"
  description = "Allow HTTP (80) and SSH (22)"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebAppSecurityGroup"
  }
}

# Database security group
resource "aws_security_group" "database_sg" {
  name        = "DatabaseSecurityGroup"
  description = "Allow MySQL (3306) and SSH (22)"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description     = "Allow Webapp access to MySQL"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_app_sg.id]
  }

  # ingress {
  #   description     = "Allow SSH from Bastion Host"
  #   from_port       = 22
  #   to_port         = 22
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.web_app_sg.id]
  # }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DatabaseSecurityGroup"
  }
}