output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "private_ips" {
  value = aws_instance.private_instances[*].private_ip
}
