variable "ubuntu_ami" {
  description = "Ubuntu 22.04 LTS AMI ID"
  default     = "ami-08c40ec9ead489470"
}

variable "amazon_ami" {
  description = "Amazon Linux 2023 AMI ID"
  default     = "ami-0c2b8ca1dad447f8a"
}
variable "ami_id" {
  description = "The AMI ID for the EC2 instances"
  type        = string
}

variable "public_key_path" {
  description = "Path to your public SSH key"
  default     = "/Users/ailsahogben/.ssh/id_ed25519.pub"
}
