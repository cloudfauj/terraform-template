locals {
  common_tags = {
    Name    = "${var.env_name}-${var.app_name}"
    manager = "cloudfauj"
  }

  app_url = "${local.common_tags.Name}.${var.apex_domain}"
}

data "aws_lb" "apps_alb" {
  name = var.env_apps_alb_name
}

resource "aws_route53_record" "app_url" {
  name    = local.app_url
  type    = "CNAME"
  zone_id = var.route53_zone_id
  ttl     = 60
  records = [data.aws_lb.apps_alb.dns_name]
}

resource "aws_alb_target_group" "alb_to_ecs_service" {
  name        = local.common_tags.Name
  vpc_id      = var.env_vpc_id
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  tags        = local.common_tags

  health_check {
    path = var.app_health_check_path
  }
}

resource "aws_lb_listener_rule" "app_router" {
  listener_arn = var.alb_listener_https_arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_to_ecs_service.arn
  }
  condition {
    host_header {
      values = [local.app_url]
    }
  }
}