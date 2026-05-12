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

# NEW: Read the public key from your Ubuntu laptop and upload it to AWS
resource "aws_key_pair" "ansible_key" {
  key_name   = "my_aws_key"
  public_key = file("~/.ssh/my_aws_key.pub")
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

output "server_ip" {
  description = "The public IP of the server"
  value       = aws_instance.my_first_server.public_ip
}
