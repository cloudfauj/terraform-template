locals {
  common_tags = {
    Name    = var.env_name
    manager = "cloudfauj"
  }
}

# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.main_vpc_cidr_block
  tags       = local.common_tags
}

# Internet gateway
resource "aws_internet_gateway" "main_vpc_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = local.common_tags
}

# Routing
resource "aws_default_route_table" "main_vpc_default_rt" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id
  tags                   = local.common_tags

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_vpc_igw.id
  }
}

# Subnets
resource "aws_subnet" "compute" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 4, 1)
  tags       = local.common_tags
}

# ECS Task IAM role shared by all applications in the environment
resource "aws_iam_role" "ecs_task_exec_role" {
  name               = "${local.common_tags.Name}-ecs-task-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_exec_role_assume_role.json
  tags               = local.common_tags
}

data "aws_iam_policy_document" "ecs_task_exec_role_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_policy" {
  policy_arn = var.iam_policy_ecs_task_exec_role
  role       = aws_iam_role.ecs_task_exec_role.name
}

resource "aws_iam_role_policy" "ecs_task_execution_role_custom_policy" {
  name   = "${local.common_tags.Name}-ecs-task-exec-role-custom-policy"
  role   = aws_iam_role.ecs_task_exec_role.id
  policy = data.aws_iam_policy_document.ecs_task_exec_role_custom_policy.json
}

data "aws_iam_policy_document" "ecs_task_exec_role_custom_policy" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = ["*"]
  }
}

# ECS Fargate cluster
resource "aws_ecs_cluster" "compute_cluster" {
  name               = local.common_tags.Name
  tags               = local.common_tags
  capacity_providers = ["FARGATE"]
}
