output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "ubuntu_private_ips" {
  value = aws_instance.ubuntu[*].private_ip
}

output "amazon_private_ips" {
  value = aws_instance.amazon[*].private_ip
}

output "ansible_controller_private_ip" {
  value = aws_instance.ansible_controller.private_ip
}
