variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "iam_role_name" {
  description = "IAM role name to attach the S3 backup policy"
  type        = string
}