provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
}

resource "aws_key_pair" "mykey" {
  key_name   = "student-key"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "bastion_sg" {
  name   = "bastion-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["69.181.93.53/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_sg" {
  name   = "private-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "SSH from bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description = "SSH within VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# Bastion instance
resource "aws_instance" "bastion" {
  ami           = "ami-0611fb750a60d769c"  # ARM64 AMI
  instance_type = "t4g.micro"              # ARM64 compatible

  subnet_id = module.vpc.public_subnet
  key_name  = "lab11b"

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]
}


# 3 Ubuntu EC2 instances
resource "aws_instance" "ubuntu" {
  count         = 3
  ami           = "ami-08c40ec9ead489470"  # Ubuntu 22.04 LTS (x86_64)
  instance_type = "t3.micro"
  subnet_id     = module.vpc.private_subnet
  key_name      = "lab11b"
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  associate_public_ip_address = false
  tags = {
    Name = "ubuntu-${count.index + 1}"
    OS   = "ubuntu"
  }
}

# 3 Amazon Linux EC2 instances
resource "aws_instance" "amazon" {
  count         = 3
  ami           = "ami-0c2b8ca1dad447f8a"  # Amazon Linux 2023 (x86_64)
  instance_type = "t3.micro"
  subnet_id     = module.vpc.private_subnet
  key_name      = "lab11b"
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  associate_public_ip_address = false
  tags = {
    Name = "amazon-${count.index + 1}"
    OS   = "amazon"
  }
}

# Ansible Controller EC2 instance (Ubuntu)
resource "aws_instance" "ansible_controller" {
  ami           = "ami-08c40ec9ead489470"  # Ubuntu 22.04 LTS (x86_64)
  instance_type = "t3.micro"
  subnet_id     = module.vpc.private_subnet
  associate_public_ip_address = false
  key_name      = "lab11b"
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  tags = {
    Name = "ansible-controller"
    OS   = "ubuntu"
    Role = "ansible-controller"
  }
}
