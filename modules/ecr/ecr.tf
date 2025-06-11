resource "aws_ecr_repository" "3line-repo" {
  name  = "3line-repo"
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = false
  }
}
