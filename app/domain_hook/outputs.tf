output "target_group_arn" {
  value = aws_alb_target_group.alb_to_ecs_service.arn
}