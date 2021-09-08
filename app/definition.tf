locals {
  common_tags = {
    Name    = "${var.env}-${var.app_name}"
    manager = "cloudfauj"
  }
}

data "aws_region" "current" {}

# Security group
resource "aws_security_group" "main_app_sg" {
  name        = local.common_tags.Name
  description = "${local.common_tags.Name} application cluster traffic control"
  vpc_id      = var.main_vpc_id
  tags        = local.common_tags

  ingress {
    description = "Application main ingress"
    from_port   = var.ingress_port
    to_port     = var.ingress_port
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

# Task Definition
resource "aws_ecs_task_definition" "main_app" {
  family                   = local.common_tags.Name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  cpu                      = var.cpu
  memory                   = var.memory

  container_definitions = jsonencode([
    {
      name  = var.app_name
      image = var.ecr_image

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-create-group"  = "true"
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-group"         = var.env
          "awslogs-stream-prefix" = var.app_name
        }
      }

      essential    = true
      portMappings = [{ containerPort = var.ingress_port }]
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "main_app" {
  name                = var.app_name
  cluster             = var.ecs_cluster_arn
  desired_count       = 1
  launch_type         = "FARGATE"
  task_definition     = aws_ecs_task_definition.main_app.arn
  scheduling_strategy = "REPLICA"

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = var.compute_subnets
    assign_public_ip = true
    security_groups  = [aws_security_group.main_app_sg.id]
  }

  // Only associate Load balancer if target group is supplied.
  dynamic "load_balancer" {
    for_each = var.lb_target_group_arns
    content {
      target_group_arn = load_balancer.value
      container_name   = var.app_name
      container_port   = var.ingress_port
    }
  }
}