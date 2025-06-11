# modules/alb/variables.tf

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets for ALB"
}

variable "container_port" {
  type        = number
  description = "Port the container listens on"
  default     = 8080
}

