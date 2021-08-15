output "name" {
  value = var.env_name
}

output "main_vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "compute_ecs_cluster_arn" {
  value = aws_ecs_cluster.compute_cluster.arn
}

output "compute_subnets" {
  value = [aws_subnet.compute.id]
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_exec_role.arn
}