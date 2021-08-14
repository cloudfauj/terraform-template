variable "app_name" {
  description = "Name of the application"
}

variable "ecs_cluster_arn" {
  description = "ARN of the ECS Fargate Cluster to deploy app to"
}

variable "main_vpc_id" {
  description = "Main VPC ID"
}