variable "app_name" {
  description = "Name of the application"
}

variable "ecs_cluster_arn" {
  description = "ARN of the ECS Fargate Cluster to deploy app to"
}

variable "main_vpc_id" {
  description = "Main VPC ID"
}

variable "ingress_port" {
  type        = number
  description = "TCP port the application will listen on for connections"
}

variable "env" {
  description = "Name of the cloudfauj environment"
}

variable "compute_subnets" {
  type        = list(string)
  description = "List of Subnets in which Fargate tasks will be placed"
}

variable "ecs_task_execution_role_arn" {
  description = "ECS Task execution role"
}

variable "cpu" {
  type        = number
  description = "Amount of CPU to allocate to an app instance"
}

variable "memory" {
  type        = number
  description = "Amount of memory to allocate to an app instance"
}

variable "ecr_image" {
  description = "The ECR docker image to deploy as part of application, including the tag"
}

variable "lb_target_group_arns" {
  default     = []
  type        = list(string)
  description = "ARNs of the Target groups through which ALBs forward traffic to app ecs service. Max 1 allowed."
}