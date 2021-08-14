module "app_nginx_api" {
  source          = "./app"
  main_vpc_id     = module.env_staging.main_vpc_id
  app_name        = "nginx-api"
  ecs_cluster_arn = module.env_staging.compute_ecs_cluster_arn
}