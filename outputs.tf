# Root outputs.tf

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = module.alb.alb_dns_name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = module.ecs.cluster_arn
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = module.ecs.service_name
}

output "website_url" {
  description = "URL of the website"
  value       = "https://3linecloud.com"
}

# The following lines of code was added for RDS deployment
output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.rds.rds_endpoint
}

output "rds_identifier" {
  description = "The ID of the RDS instance"
  value       = module.rds.rds_identifier
}

output "database_url" {
  value     = module.rds.db_url
  sensitive = true
}

output "database_host" {
  value = module.rds.db_host
}

# The following lines of code was added for Amplify deployment
output "amplify_app_url" {
  value = module.amplify.amplify_app_url
}

output "amplify_app_id" {
  value = module.amplify.amplify_app_id
}
