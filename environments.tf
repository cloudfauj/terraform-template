module "staging" {
  source              = "./env"
  env_name            = "staging"
  main_vpc_cidr_block = "10.0.0.0/16"
}

module "raghavtest1" {
  source              = "./env"
  env_name            = "raghavtest1"
  main_vpc_cidr_block = "10.17.0.0/16"
}
