locals {
  common_tags = {
    Name    = var.env_name
    manager = "cloudfauj"
  }
}

resource "aws_security_group" "env_apps_alb" {
  name        = "${var.env_name}-apps-alb"
  description = "${var.env_name} applications ALB traffic control"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "${var.env_name}-alb"
    manager = local.common_tags.manager
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "env_apps" {
  name               = var.env_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.env_apps_alb.id]
  tags               = local.common_tags
  subnets            = var.alb_subnets
}

resource "aws_alb_listener" "env_apps_https" {
  load_balancer_arn = aws_alb.env_apps.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Service Unavailable"
      status_code  = "503"
    }
  }
}