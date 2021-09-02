output "apps_alb_arn" {
  value = aws_alb.env_apps.arn
}

output "apps_alb_name" {
  value = aws_alb.env_apps.name
}

output "main_alb_https_listener" {
  value = aws_alb_listener.env_apps_https.arn
}