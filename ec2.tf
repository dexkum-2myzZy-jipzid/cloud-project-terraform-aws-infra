# WebApp instance
resource "aws_instance" "web_app_instance" {
  ami           = var.webapp_ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_app_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "Setup start: $(date)"
    cd /opt/webapp || { echo "Failed to change directory /opt/webapp"; exit 1; }
    
    echo "Creating .env file..."
    echo "DB_HOST=${aws_instance.database_instance.private_ip}" > .env
    echo "DB_USER=${var.database_username}" >> .env
    echo "DB_PASSWORD=${var.database_password}" >> .env
    echo "DB_NAME=${var.db_name}" >> .env
    echo "FLASK_SECRET=${var.webapp_secret_key}" >> .env

    sudo chown csye6225:csye6225 /opt/webapp/.env
    sudo chmod 600 /opt/webapp/.env
    sudo systemctl restart webapp.service
  EOF
  )

  depends_on = [aws_instance.database_instance]

  tags = {
    Name = "WebAppInstance"
  }
}

# Database instance
resource "aws_instance" "database_instance" {
  ami           = var.mysql_ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids      = [aws_security_group.database_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "DatabaseInstance"
  }
}


resource "null_resource" "run_tests" {
  depends_on = [aws_instance.web_app_instance]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for instance to be ready..."
      sleep 30
    EOT
  }
}