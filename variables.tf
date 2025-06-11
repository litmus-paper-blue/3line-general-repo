variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# variable "bucket_name" {
#   description = "Name of the S3 bucket"
#   type        = string
# }

variable "ecr_name" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "task_definition_family" {
  type = string
}
variable "ecs_task_execution_role_name" {
  type = string
}

variable "execution_role_policy" {
  type = string
}

variable "ecs_task_role" {
  type = string
}

variable "task_role_policy" {
  type = string
}
variable "container_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "access_key" {
  type = string
}

variable "secret_access_key" {
  type = string
}

variable "bucket_name" {
  type        = string
  description = "frontend-bucket-name"
  default     = "netiks-test-new-frontend3338"
}

# The following lines of code was added for RDS deployment
variable "allocated_storage" {
  description = "The allocated storage in GB"
  type        = number
  default     = 20
}

# variable "engine" {
#   description = "The database engine (e.g. mysql, postgres)"
#   type        = string
#   default     = "postgres"
# }

# variable "engine_version" {
#   description = "The version of the engine"
#   type        = string
#   default     = "15.3"
# }

variable "instance_class" {
  description = "The RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
  default     = "netiks_db_user"
}

variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
  # sensitive   = true
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

# The following lines of code was added for Amplify deployment
variable "amplify_app_name" {
  description = "Name of the Amplify app"
  type        = string
}

variable "amplify_repository" {
  description = "Repository connected to the Amplify app"
  type        = string
}

variable "amplify_oauth_token" {
  description = "OAuth token for GitHub"
  type        = string
  sensitive   = true
}

variable "amplify_branch_name" {
  description = "Branch name for Amplify to build"
  type        = string
}

# variable "environment_variables" {
#   type        = map(string)
#   description = "Environment variables for the Amplify app"
# }
# Added update for amplify
# variable "amplify_service_role_name" {
#   description = "The name of the IAM role for AWS Amplify"
#   type        = string
#   default     = "amplify-service-role"
# }