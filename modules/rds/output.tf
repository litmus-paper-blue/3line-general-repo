output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.this.endpoint
}

output "rds_identifier" {
  description = "The ID of the RDS instance"
  value       = aws_db_instance.this.id
}

output "db_host" {
  value = aws_db_instance.this.endpoint
}

output "db_url" {
  value = "postgresql://${var.username}:${var.password}@${aws_db_instance.this.endpoint}:${aws_db_instance.this.port}/${var.db_name}"
  
}
