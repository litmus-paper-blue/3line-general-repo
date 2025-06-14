# provider "aws" {
#   region = var.aws_region
# }

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  environment          = var.environment
}

module "ecr" {
  source = "./modules/ecr"

  ecr_name = var.ecr_name
}



module "ecs" {
  source = "./modules/ecs"

  task_execution_role_arn = module.iam.task_execution_role_arn
  task_role_arn           = module.iam.task_role_arn
  ecs_cluster_name        = var.ecs_cluster_name
  task_definition_family  = var.task_definition_family
  container_name          = var.container_name
  region                  = "us-east-1"
  image_url               = "${module.ecr.repository_url}:latest"
  service_name            = var.service_name
  target_group_arn        = module.alb.target_group_arn
  subnets                 = module.vpc.private_subnet_ids
  security_groups         = [module.alb.security_group_id] # Changed to list
  vpc_id                  = module.vpc.vpc_id
  alb_security_group_id   = module.alb.security_group_id
}

module "iam" {
  source                       = "./modules/iam"
  ecs_task_execution_role_name = var.ecs_task_execution_role_name
  execution_role_policy        = var.execution_role_policy
  ecs_task_role                = var.ecs_task_role
  task_role_policy             = var.task_role_policy

}

module "alb" {
  source = "./modules/alb"

  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  container_port = 8000

}


module "website" {
  source = "./modules/website"

  bucket_name    = var.bucket_name
  domain_name    = "3linecloud.com"
  hosted_zone_id = "Z0531560VFJZ58O47736"

  tags = {
    Environment = "test"
    Project     = "3line-frontend"
    ManagedBy   = "Terraform"
  }
}

# The following lines of code was added for RDS deployment
module "rds" {
  source                 = "./modules/rds"
  environment            = var.environment
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "17.2"
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  subnet_ids             = module.vpc.public_subnet_ids
  vpc_security_group_ids = [module.vpc.database_sg]
  multi_az               = var.multi_az
}

# The following lines of code was added for Amplify deployment
module "amplify" {
  source                = "./modules/amplify"

  app_name              = var.amplify_app_name
  repository            = var.amplify_repository
  oauth_token           = var.amplify_oauth_token
  branch_name           = var.amplify_branch_name
  # Added line of code for Amplify
  amplify_service_role_arn = module.iam.amplify_service_role_arn
}



