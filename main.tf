provider "aws" {
  region = "ap-south-1"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "allow_web_traffic"
  description = "Allow HTTP and SSH inbound traffic"

  # Allow HTTP (Port 80) for the website
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # NEW: Allow SSH (Port 22) so Ansible can log in!
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # In a real job, you restrict this to your specific IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_key_pair" "ansible_key" {
  key_name   = "my_aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCyPimmDYJqSpRiY27Rhc01Xh0SGCyGsOFWAQNPJI8Z0sgDKdPnTYcwQYgup9KPm0gaXZ5nmayDQJYCLHjoYzdMwhy0o242wPWYvmxFlwPjO9kuQa3Y//E9ACLJvl1mWqML0dZB1lM3bIP2/daQDsNCbY87rWwIgtJHbhF9SKzPIL7sFO4WQDT8U1bwJs6tdo7rrf0Lq41GXgREPhj60ninLr+F8RVEneVXjX8w4JjsnGTkWsu+yOb6NiZZo73rRfK+8o7T/FSZI5Adb7iqCUcdFqWVewc/kR2BsmCTgUOdqnCY3SvsZwMEfDdVnpIe/1z7re6X4eFUv5WAbH1CrFurkhyo02SF4A04p3bE+qdoEz0fv2ulwlYUyz6ptApERrHCQ/t7kSHh7Pi4e1hlr0i0eZluF40TiPXuKxXZ1EUca3fmGMb3kcLjkzpfy2L/GEEBejQZHl0zr+g84kK3nRi0Bpi/o9qFHDdwydcaOuBfg5nHB6lLnCcfEMYc8XiB0yXBl8qwQmHnyFezd7j5NYZM0ljT4MX+lCHRC65MS4BJ9+JHh0zWswudbSdzWMP6pIkm/q1WxVvfe3xkK75TdScOgC3TaDJcp7jDP9dke16pUzHuB6BH5gv1JoxXD8chiqCTeC3YLvYLGz3klklYvjzPPi/trczaHzjYaAEjtnrgaw== finstein-emp@fin-pf46xkg6"
}

resource "aws_instance" "my_first_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # NEW: Attach the padlock to the server
  key_name = aws_key_pair.ansible_key.key_name

  tags = {
    Name = "Ansible-Target-Server"
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-state-subash-636987"
    key    = "prod/terraform.tfstate"
    region = "ap-south-1"
  }
}

output "server_ip" {
  description = "The public IP of the server"
  value       = aws_instance.my_first_server.public_ip
}
