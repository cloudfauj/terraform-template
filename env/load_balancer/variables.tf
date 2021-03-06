variable "env_name" {
  description = "Name of the environment"
}

variable "vpc_id" {
  description = "ID of the VPC of the environment"
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate provisioned for the domain associated with the environment"
}

variable "alb_subnets" {
  type        = list(string)
  description = "IDs of subnets that will contain the ALB. Exactly 2 required."
}