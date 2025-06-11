variable "bucket_name" {
  description = "Name of the S3 bucket to store frontend assets"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the frontend application (e.g., app.example.com)"
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional domain names for the SSL certificate"
  type        = list(string)
  default     = []
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID for the domain"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "create_www_redirect" {
  description = "Whether to create a www subdomain that redirects to the apex domain"
  type        = bool
  default     = false
}





