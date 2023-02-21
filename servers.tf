# Author    : Jaydeep Dutta
#LinkedIn   : www.linkedin.com/in/jaydeepdutta95
#GitHub     : https://github.com/jaydeepdutta95
#Hashnode   : https://jaydeep2022.hashnode.dev/
########################################################

resource "aws_instance" "web" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  key_name                    = "jaydeep1387"
  subnet_id                   = aws_subnet.public[count.index].id
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  associate_public_ip_address = true
  count                       = 2

  user_data = <<-EOF
        #!/bin/bash
          sudo yum update -y
          sudo yum install -y httpd.x86_64
          sudo systemctl start httpd.service
          sudo systemctl enable httpd.service
          echo “Welcome and Learn with Jaydeep from $(hostname -f)” > /var/www/html/index.html
        EOF

  tags = {
    Name = "Web_Server_${count.index}"
  }

  provisioner "file" {
    source      = "./jaydeep1387.pem"
    destination = "/home/ec2-user/jaydeep1387.pem"

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("./jaydeep1387.pem")
    }
  }
}

resource "aws_instance" "db" {
  ami                    = var.ec2_ami
  instance_type          = var.instance_type
  key_name               = "jaydeep1387"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.allow_tls_db.id]

  tags = {
    Name = "Database_server"
  }
}
