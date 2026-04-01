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
    cidr_blocks = ["138.202.129.187/32"]
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
  key_name  = "lab8"

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]
}

# Private instances
resource "aws_instance" "private_instances" {
  count         = 6
  ami           = "ami-0611fb750a60d769c"  # ARM64 AMI
  instance_type = "t4g.micro"              # ARM64 compatible

  subnet_id = module.vpc.private_subnet
  key_name  = "lab8"

  vpc_security_group_ids = [
    aws_security_group.private_sg.id
  ]

  associate_public_ip_address = false
}
