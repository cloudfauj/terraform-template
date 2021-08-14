output "main_vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "compute_ecs_cluster_arn" {
  value = aws_ecs_cluster.compute_cluster.arn
}