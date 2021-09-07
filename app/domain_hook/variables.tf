variable "app_name" {
  description = "Name of the application"
}

variable "app_health_check_path" {
  description = "Health check endpoint of the app that returns 200"
}

variable "env_name" {
  description = "Name of the environment of the app"
}

variable "env_vpc_id" {
  description = "ID of the VPC of the environment"
}

variable "env_apps_alb_name" {
  description = "Name of the environment's main apps ALB"
}

variable "alb_listener_https_arn" {
  description = "ARN of the HTTPS listener of the environment's ALB"
}

variable "apex_domain" {
  description = "Apex Domain associated with the environment"
}

variable "route53_zone_id" {
  description = "ID of the Route53 hosted zone controlling the domain"
}
