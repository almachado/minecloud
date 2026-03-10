variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
}

variable "allowed_ip" {
  description = "Authorized IP address for SSH and Minecraft server access (format: x.x.x.x/32)"
  type        = string
}