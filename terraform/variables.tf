variable "ami_id" {
  description = "The AMI ID for the EC2 instances"
  type        = string
}

variable "public_key_path" {
  description = "Path to your public SSH key"
  default     = "/Users/ailsahogben/.ssh/id_ed25519.pub"
}
