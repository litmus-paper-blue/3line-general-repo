resource "aws_amplify_app" "this" {
  name       = var.app_name
  repository = var.repository
  oauth_token = var.oauth_token
  platform    = "WEB_COMPUTE"
  #Add IAM code for Amplify
  iam_service_role_arn = var.amplify_service_role_arn


  # Build specification matching amplify.yml
  build_spec = <<BUILD_SPEC
version: 1
frontend:
  phases:
    preBuild:
      commands:
        - npm ci --cache .npm --prefer-offline
    build:
      commands:
        - npm run build
  artifacts:
    baseDirectory: .next
    files:
      - '**/*'
  cache:
    paths:
      - .next/cache/**/*
      - .npm/**/*
BUILD_SPEC



  custom_rule {
    source = "/<*>"
    target = "/index.html"
    status = "404"
  }

  enable_branch_auto_build = true
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.this.id
  branch_name = var.branch_name
  stage       = "PRODUCTION"
  enable_pull_request_preview = false
}
