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
  tags        = local.common_tags

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

resource "aws_subnet" "env_apps_alb" {
  count      = 2
  vpc_id     = var.vpc_id
  cidr_block = var.alb_subnet_cidrs[count.index]
  tags       = local.common_tags
}

resource "aws_alb" "env_apps" {
  name               = var.env_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.env_apps_alb.id]
  tags               = local.common_tags
  subnets            = aws_subnet.env_apps_alb.*.id
}

resource "aws_alb_listener" "env_apps_http" {
  load_balancer_arn = aws_alb.env_apps.arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
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