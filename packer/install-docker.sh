#!/bin/bash
set -e

# Update packages
sudo yum update -y

# Install required packages
sudo amazon-linux-extras enable docker
sudo yum install -y docker

# Start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Add ec2-user to docker group so no sudo is needed
sudo usermod -aG docker ec2-user

# Verify Docker installation
docker --version
