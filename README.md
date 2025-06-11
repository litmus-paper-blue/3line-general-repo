# 3line Infrastructure Setup Guide

## Overview
This repository contains Terraform configurations for deploying the 3line infrastructure on AWS, including VPC, ECS, ECR, S3, Route53, Cloudfront and ALB resources 

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or later)
- AWS CLI configured
- Access to AWS account with appropriate permissions

## Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/cog3line/3line_infra.git
cd 3line_infra
```

### 2. Configure AWS Credentials
You'll need to set up your AWS credentials. Create a `terraform.tfvars` file using the provided sample:

1. Copy the sample variables file:
```bash
cp sampletfvars.txt terraform.tfvars
```

2. Edit `terraform.tfvars` and add your AWS credentials:
```hcl
aws_region         = "us-east-1"
environment        = "dev"
container_name     = "3line-container"
ecs_cluster_name   = "3line-cluster"
ecr_name          = "3line-ecr"
# ... other variables ...

# Add your AWS credentials here
access_key         = "YOUR_AWS_ACCESS_KEY"
secret_access_key  = "YOUR_AWS_SECRET_KEY"
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Review the Infrastructure Plan
```bash
terraform plan
```

### 5. Apply the Infrastructure
```bash
terraform apply
```
When prompted, type `yes` to proceed with the creation.


CI/CD Pipeline
This repository includes GitHub Actions workflows that automate Terraform validation, planning, and application processes.
Setting Up the CI/CD Pipeline
1. Configure GitHub Secrets
You need to manually add the following secrets to your GitHub repository:

Navigate to your GitHub repository
Go to Settings → Secrets and variables → Actions
Add the following secrets:

AWS_ACCESS_KEY_ID: Your AWS access key
AWS_SECRET_ACCESS_KEY: Your AWS secret access key



2. Understanding sampletfvars.txt and CI/CD Workflow
The repository includes a sampletfvars.txt file that defines your infrastructure configuration variables. This file is committed to the repository and used by the CI/CD pipeline to dynamically generate your Terraform variables.
How the sampletfvars.txt process works:

The workflow reads each line from sampletfvars.txt
It converts each variable to environment variables with the TF_VAR_ prefix
It then creates a terraform.tfvars file during runtime with all these variables
AWS credentials from GitHub Secrets are automatically added to this file
This approach allows you to keep your configuration in source control while keeping credentials secure

Your sampletfvars.txt looks like:
aws_region    = "us-east-1"
environment   = "dev"
container_name = "3line-container"
ecs_cluster_name = "3line-cluster"
ecr_name = "3line-ecr"
task_definition_family = "3line-task-td"
service_name = "3line-service"
ecs_task_execution_role_name = "3line-ecs-execution-role"
task_role_policy = "ecs-task-base-policy"
ecs_task_role = "3line-ecs-task-role"
execution_role_policy = "value"
3. CI/CD Workflow Files
The repository contains two GitHub Actions workflow files:

Pull Request Validation Workflow (validate-pr.yml):

Triggers when pull requests are opened or updated against the main branch
Watches for changes in .tf files, /modules directory, and the workflow file itself
Performs:

terraform init - Initializes the Terraform environment
terraform validate - Checks for configuration errors
terraform plan - Creates an execution plan


Uploads the plan as an artifact for review
The plan is available for 2 days for inspection


Terraform Apply Workflow (terraform-apply.yml):

Triggers when changes are pushed (merged) to the main branch
Watches for changes in .tf files, /modules directory, and the workflow file itself
Performs:

terraform init - Initializes the Terraform environment
terraform plan - Creates an execution plan
terraform apply - Implements the changes


Uses the GitHub Environment "production" for additional protection
Can be configured with approval gates via GitHub Environments



4. CI/CD Workflow Process
For Pull Requests:

Developer creates a branch and makes changes to Terraform files
Developer opens a pull request against main
The validation workflow automatically runs and validates the changes
The execution plan is saved as an artifact for review
After review and approval, the PR can be merged to main

For Main Branch Deployments:

When changes are merged to main, the apply workflow is triggered
If configured, approval gates in GitHub Environment settings can be used
The workflow applies the changes to the AWS environment
Infrastructure is updated according to the merged changes

## Infrastructure Components
- **VPC**: Creates a VPC with public and private subnets
- **ECR**: Container registry for Docker images
- **ECS**: Fargate cluster for running containers
- **ALB**: Application Load Balancer for routing traffic

## Important Notes
- The backend is configured to use S3 for state storage
- Make sure your AWS credentials have sufficient permissions
- Keep your `terraform.tfvars` file secure and never commit it to version control
- The infrastructure is set up in the `us-east-1` region by default

## Clean Up
To destroy the infrastructure:
```bash
terraform destroy
```

## Security Considerations
- Never commit `terraform.tfvars` containing real credentials
- Use AWS IAM best practices for access keys
- Rotate access keys periodically
- Consider using AWS Secrets Manager for sensitive values

## Outputs
After successful deployment, you'll get:
- VPC ID
- ECR repository URL
- ALB DNS name
- ECS cluster ARN
- ECS service name
