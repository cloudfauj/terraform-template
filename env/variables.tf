variable "iam_policy_ecs_task_exec_role" {
  default     = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  description = "ARN of AWS-managed IAM policy AmazonECSTaskExecutionRolePolicy"
}

variable "env_name" {
  description = "Name of the environment"
}

variable "main_vpc_cidr_block" {
  description = "CIDR block of the main VPC"
}