variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  default     = "minecloud"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "allowed_ip" {
  description = "Authorized IP address for SSH and Minecraft server access (format: x.x.x.x/32)"
  type        = string
}