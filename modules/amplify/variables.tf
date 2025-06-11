variable "app_name" {
  type        = string
  description = "The name of the Amplify app"
}

variable "repository" {
  type        = string
  description = "GitHub repository connected to the Amplify app"
}

variable "oauth_token" {
  type        = string
  description = "GitHub OAuth token for Amplify access"
  sensitive   = true
}

variable "branch_name" {
  type        = string
  description = "Branch name to deploy from"
}

# variable "environment_variables" {
#   type        = map(string)
#   description = "Environment variables for the Amplify app"
# }
#Add IAM code for Amplify
variable "amplify_service_role_arn" {
  description = "IAM role ARN for Amplify service"
  type        = string
}