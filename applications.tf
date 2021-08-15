# app module name also needs to contain env name
module "staging_nginx_api" {
  source                      = "./app"
  main_vpc_id                 = module.staging.main_vpc_id
  ecs_cluster_arn             = module.staging.compute_ecs_cluster_arn
  compute_subnets             = module.staging.compute_subnets
  ecs_task_execution_role_arn = module.staging.ecs_task_execution_role_arn
  env                         = module.staging.name

  # cpu, mem need to be rounded for fargate
  app_name     = "nginx-api"
  ingress_port = 8080
  cpu          = 256
  memory       = 512
  ecr_image    = "037616467826.dkr.ecr.ap-south-1.amazonaws.com/demo-server:ping"
}

module "staging_raghavapi" {
  source                      = "./app"
  main_vpc_id                 = module.staging.main_vpc_id
  ecs_cluster_arn             = module.staging.compute_ecs_cluster_arn
  compute_subnets             = module.staging.compute_subnets
  ecs_task_execution_role_arn = module.staging.ecs_task_execution_role_arn
  env                         = module.staging.name

  # cpu, mem need to be rounded for fargate
  app_name     = "raghavapi"
  ingress_port = 8080
  cpu          = 256
  memory       = 512
  ecr_image    = "037616467826.dkr.ecr.ap-south-1.amazonaws.com/demo-server:latest"
}

module "raghavtest1_nginx_api" {
  source                      = "./app"
  main_vpc_id                 = module.raghavtest1.main_vpc_id
  ecs_cluster_arn             = module.raghavtest1.compute_ecs_cluster_arn
  compute_subnets             = module.raghavtest1.compute_subnets
  ecs_task_execution_role_arn = module.raghavtest1.ecs_task_execution_role_arn
  env                         = module.raghavtest1.name

  # cpu, mem need to be rounded for fargate
  app_name     = "nginx-api"
  ingress_port = 8080
  cpu          = 256
  memory       = 512
  ecr_image    = "037616467826.dkr.ecr.ap-south-1.amazonaws.com/demo-server:ping"
}
