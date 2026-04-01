packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "amazon-linux" {
  region            = "us-east-1"
  instance_type     = "t4g.micro"      # ARM64-compatible
  ami_name          = "docker-ami-arm64-{{timestamp}}"
  source_ami        = "ami-02eed9edabad601a5" # Amazon Linux 2 ARM64
  ssh_username      = "ec2-user"
}

build {
  name    = "docker-ami-arm64"
  sources = ["source.amazon-ebs.amazon-linux"]

  provisioner "shell" {
    script = "install-docker.sh"
  }
}
