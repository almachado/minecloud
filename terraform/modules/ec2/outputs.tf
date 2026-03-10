output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.main.public_ip
}

output "ebs_volume_id" {
  description = "ID of the EBS data volume"
  value       = aws_ebs_volume.data.id
}