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

  user_data = base64encode(<<-EOF
    #!/bin/bash
    until lsblk | grep -q xvdf; do
      echo "Waiting for EBS volume..."
      sleep 10
    done

    sleep 30

    # mount EBS volume
    sudo mount -a

    # setting Permissions
    sudo chown -R mysql:mysql /mnt/mysql-data

    # stop and start MySQL
    sudo systemctl stop mysql
    sudo systemctl start mysql
  EOF
  )

  tags = {
    Name = "DatabaseInstance"
  }
}

# Attach existing EBS volume to database instance
resource "aws_volume_attachment" "db_data_attachment" {
  device_name = "/dev/sdf"
  volume_id   = var.db_volume_id
  instance_id = aws_instance.database_instance.id

  force_detach = true
}

# # Initialize EBS volume using null_resource + remote-exec
# resource "null_resource" "init_db_volume" {
#   depends_on = [
#     aws_instance.database_instance,
#     aws_volume_attachment.db_data_attachment
#   ]

#   provisioner "remote-exec" {
#     connection {
#       type = "ssh"

#       # Bastion host configuration
#       bastion_host        = aws_instance.web_app_instance.public_ip
#       bastion_user        = "ubuntu"
#       bastion_private_key = file(var.private_key_path)

#       # Connect to database instance using private IP
#       host        = aws_instance.database_instance.private_ip
#       user        = "ubuntu"
#       private_key = file(var.private_key_path)
#     }

#     inline = [
#       "echo 'Checking EBS volume...'",
#       "if ! lsblk | grep -q xvdf; then",
#       "  echo 'ERROR: EBS volume not detected!'",
#       "  exit 1",
#       "fi",
#       "echo 'Mounting EBS volume...'",
#       "sudo mkdir -p /mnt/mysql-data || exit 1",
#       "sudo mount /dev/xvdf /mnt/mysql-data || true",
#       "echo '/dev/xvdf /mnt/mysql-data ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab || exit 1",
#       "echo 'Setting permissions...'",
#       "sudo chown -R mysql:mysql /mnt/mysql-data || exit 1",
#       "echo 'Restarting MySQL service...'",
#       "sudo systemctl restart mysql || exit 1"
#     ]
#   }
# }