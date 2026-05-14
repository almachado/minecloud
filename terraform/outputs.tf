output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2.public_ip
}

output "ebs_volume_id" {
  description = "ID of the EBS data volume"
  value       = module.ec2.ebs_volume_id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "backup_bucket_name" {
  description = "Name of the S3 backup bucket"
  value       = module.s3_backup.bucket_name
}