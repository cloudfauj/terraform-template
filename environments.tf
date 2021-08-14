module "env_staging" {
  source              = "./env"
  env_name            = "staging"
  main_vpc_cidr_block = "10.0.0.0/16"
}