output "amplify_app_id" {
  value = aws_amplify_app.this.id
}

output "amplify_app_arn" {
  value = aws_amplify_app.this.arn
}

output "amplify_app_url" {
  value = aws_amplify_app.this.default_domain
}
